require 'spec_helper_acceptance'

pp_basic = <<-PUPPETCODE
  class{tailscale: auth_key => Sensitive('no_auth_key_12345') }

PUPPETCODE
# because we use node encrypt we are unable to test
idempotent_apply(pp_basic)

describe 'tailscale' do
  describe package('tailscale') do
    it { is_expected.to be_installed }
  end

  describe service('tailscale') do
    it { is_expected.to be_enabled }
  end
end
