# @summary
#
# Installs tailscale and adds to the network via tailscale up
#
# @example
#   include tailscale
class tailscale(
  String $auth_key,
  Hash $up_options = {}
) {

  apt::source { 'tailscale':
    comment  => 'Tailscale packages for ubuntu',
    location => 'https://pkgs.tailscale.com/stable/ubuntu',
    #release  => 'focal',
    require  => Apt_key['tailscale']
  }
  package{'tailscale':
    ensure  => present,
    require => Apt::Source['tailscale']
  }
  apt_key{'tailscale':
    ensure => present,
    id     => '2596A99EAAB33821893C0A79458CA832957F5868',
    source => 'https://pkgs.tailscale.com/stable/ubuntu/focal.gpg'
  }

  $up_cli_options =  $up_options.merge({authkey => $auth_key}).map |$key, $value| { "-${key} ${value}"}.join(' ')

  exec{'run tailscale up':
    command  => "tailscale up ${up_cli_options}",
    provider => shell,
    unless   => 'tailscale status',
    require  => Package['tailscale']
  }

}
