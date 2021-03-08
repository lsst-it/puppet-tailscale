require 'spec_helper_acceptance'

pp_basic = <<-PUPPETCODE
  class{tailscale: auth_key => 'fail' }

PUPPETCODE


idempotent_apply(pp_basic)

describe package('tailscale') do
  it { should be_installed }
end

describe file('/etc/apt/sources.list.d/tailscale.list') do
  it { should exist }
  its(:content) { should eql?('deb https://pkgs.tailscale.com/stable/ubuntu focal main') }
end

