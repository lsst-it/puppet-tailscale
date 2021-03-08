# frozen_string_literal: true

require 'spec_helper'

describe 'tailscale' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { {auth_key: '123456'} }
      it { is_expected.to compile }
    end
  end
end
