# @summary
#
# Installs tailscale and adds to the network via tailscale up
#
# @param auth_key
#   the authorization key either onetime or multi-use
#
# @param base_pkg_url
#   the base url of where to get the package
#
# @param manage_package_repository
#   the options determines if the official tailscale repository should be managed or not
#
# @param manage_package
#   the options determines if the installation of the package should be managed or not
#
# @param manage_service
#   the options determines if the service should be managed (started and enabled) or not
#
# @param up_options
#   the options to use when running tailscale up for the first time
#
# @param use_node_encrypt
#   use node encrypt when running tailscale up.  This requires a puppetserver and node encrypt
# @example
#   include tailscale
class tailscale (
  Variant[String, Sensitive[String]] $auth_key,
  Stdlib::HttpUrl $base_pkg_url,
  Boolean $manage_package = true,
  Boolean $manage_service = true,
  Boolean $manage_package_repository = true,
  Hash $up_options = {},
  Boolean $use_node_encrypt = false
) {
  if $manage_package_repository {
    case $facts['os']['family'] {
      'Debian': {
        file { '/usr/share/keyrings/tailscale.gpg':
          source => 'puppet:///modules/tailscale/tailscale.gpg',
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
        }
        apt::source { 'tailscale':
          comment  => 'Tailscale packages for Debian/Ubuntu',
          location => $base_pkg_url,
          repos    => 'main',
          release  => $::facts['os']['distro']['codename'],
          keyring  => '/usr/share/keyrings/tailscale.gpg',
          require  => File['/usr/share/keyrings/tailscale.gpg'],
          before   => Package['tailscale'],
        }
        apt_key { 'tailscale':
          ensure => absent,
          id     => '2596A99EAAB33821893C0A79458CA832957F5868',
        }
      }
      'RedHat': {
        yumrepo { 'tailscale-stable':
          ensure   => 'present',
          descr    => 'Tailscale stable',
          baseurl  => "${base_pkg_url}/${facts['os']['release']['major']}/\$basearch",
          gpgkey   => "${base_pkg_url}/${facts['os']['release']['major']}/repo.gpg",
          enabled  => '1',
          gpgcheck => '0',
          target   => '/etc/yum.repo.d/tailscale-stable.repo',
        }
      }
      default: {
        fail('OS not support for tailscale')
      }
    }
  }
  if $manage_package {
    package { 'tailscale':
      ensure  => present,
    }
    if ( $facts['os']['family'] == 'Debian' and $manage_package_repository == true) {
      # make sure we update the package list before trying to install the package
      # TODO: check if a similar workaround is also needed for RedHat
      Exec['apt_update'] ~> Package['tailscale']
    }
  }
  if ($::facts.dig('os', 'distro', 'id') == 'Pop') {
    $service_provider = 'systemd'
  } else {
    $service_provider = undef
  }
  if $manage_service {
    service { 'tailscaled':
      ensure   => running,
      enable   => true,
      provider => $service_provider,
      require  => [Package['tailscale']],
    }
  }

  $up_cli_options =  $up_options.map |$key, $value| {
    $equalsval = $value ? {
      String[1] => "=${value}",
      Boolean   => "=${bool2str($value)}",
      default   => '',
    }
    "--${key}${equalsval}"
  }.join(' ')

  if $use_node_encrypt {
    # uses node encrypt to unwrap the sensitive value then encrypts it
    # on the command line during execution the value is decrypted and never exposed to logs since the value
    # is temporary only exposed in a env variable
    $ts_command = "tailscale up --authkey=\$(puppet node decrypt --env SECRET) ${up_cli_options}".rstrip
    $env = ["SECRET=${node_encrypt($auth_key.unwrap)}"]
  } else {
    $ts_command = "tailscale up --authkey=\$SECRET ${up_cli_options}".rstrip
    $env = ["SECRET=${auth_key.unwrap}"]
  }
  exec { 'run tailscale up':
    command     => $ts_command,
    provider    => shell,
    environment => $env,
    unless      => 'test $(tailscale status | wc -l) -gt 1',
    require     => Service['tailscaled'],
  }
}
