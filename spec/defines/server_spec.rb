require 'spec_helper'

describe 'openvpn::server' do
  let(:title) { 'main' }
  let(:params) do
    {
      server: '192.168.0.0',
      netmask: '255.255.255.0',
      tls_auth_enabled: tls_auth_enabled,
      tls_auth_content: tls_auth_content,
      tls_auth_file: tls_auth_file,
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

  it do
    is_expected.to contain_openvpn__config('main').with(
      server: '192.168.0.0',
      netmask: '255.255.255.0',
    )
  end

  describe 'tls_auth_enabled' do
    describe 'generated' do
      let(:tls_auth_enabled) { true }

      it { is_expected.to contain_exec('/usr/sbin/openvpn --genkey --secret "/etc/openvpn/main-ta.key"') }
      it { is_expected.to contain_file('/etc/openvpn/main-ta.key') }
    end

    describe 'with tls_auth_content' do
      let(:tls_auth_content) { 'bloub' }

      it { is_expected.to contain_file('/etc/openvpn/main-ta.key').with(content: 'bloub') }
    end

    describe 'with tls_auth_file' do
      let(:tls_auth_file) { '/bloub' }

      it { is_expected.to_not contain_file('/etc/openvpn/main-ta.key') }
    end
  end
end
