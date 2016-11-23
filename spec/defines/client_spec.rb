require 'spec_helper'

describe 'openvpn::client' do
  let(:title) { 'client' }
  let(:params) do
    {
      remote_host: '203.0.113.27',
      tls_auth_enabled: tls_auth_enabled,
      tls_auth_content: tls_auth_content,
      tls_auth_file: tls_auth_file,
      manage_service: manage_service,
    }
  end
  let(:facts) do
    {
      osfamily: 'Debian',
    }
  end
  let(:tls_auth_enabled) { :undef }
  let(:tls_auth_content) { :undef }
  let(:tls_auth_file) { :undef }
  let(:manage_service) { :undef }

  it do
    is_expected.to contain_openvpn__config('client').with(
      remote_host: '203.0.113.27',
    )
  end

  describe 'manage_service' do
    describe 'enabled' do
      let(:manage_service) { true }

      it { is_expected.to contain_service('openvpn-client') }
    end

    describe 'disabled' do
      let(:manage_service) { false }

      it { is_expected.not_to contain_service('openvpn-client') }
    end
  end

  describe 'tls_auth_enabled' do
    let(:tls_auth_enabled) { true }

    describe 'with tls_auth_content' do
      let(:tls_auth_content) { 'bloub' }

      it { is_expected.to contain_file('/etc/openvpn/client-ta.key').with(content: 'bloub') }
    end

    describe 'with tls_auth_file' do
      let(:tls_auth_file) { '/bloub' }

      it { is_expected.to_not contain_file('/etc/openvpn/client-ta.key') }
    end

    describe 'without tls_auth_content nor tls_auth_file' do
      it { is_expected.to compile.and_raise_error(/Enabling 'tls_auth_enabled' requires setting 'tls_auth_content' or 'tls_auth_file' too./) }
    end
  end
end
