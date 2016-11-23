require 'spec_helper'

describe 'openvpn::server' do
  let(:title) { 'main' }
  let(:params) do
    {
      server_network: '192.168.0.0',
      server_netmask: '255.255.255.0',
      ifconfig_pool_persist_enabled: ifconfig_pool_persist_enabled,
      ifconfig_pool_persist_file: ifconfig_pool_persist_file,
      tls_auth_enabled: tls_auth_enabled,
      tls_auth_content: tls_auth_content,
      tls_auth_file: tls_auth_file,
      manage_service: manage_service
    }
  end
  let(:facts) do
    {
      osfamily: 'Debian',
    }
  end
  let(:ifconfig_pool_persist_enabled) { :undef }
  let(:ifconfig_pool_persist_file) { :undef }
  let(:tls_auth_enabled) { :undef }
  let(:tls_auth_content) { :undef }
  let(:tls_auth_file) { :undef }
  let(:manage_service) { false }

  it do
    is_expected.to contain_openvpn__config('main').with(
      server_network: '192.168.0.0',
      server_netmask: '255.255.255.0',
    )
  end

  describe 'manage_service' do
    describe 'enabled' do
      let(:manage_service) { true }

      it { is_expected.to contain_service('openvpn-main') }
    end

    describe 'disabled' do
      let(:manage_service) { false }

      it { is_expected.not_to contain_service('openvpn-main') }
    end
  end

  describe 'ifconfig_pool_persist_enabled' do
    let(:ifconfig_pool_persist_enabled) { true }

    it { is_expected.to contain_file('/etc/openvpn/main-ipp.txt') }

    describe 'with ifconfig_pool_persist_file' do
      let(:ifconfig_pool_persist_file) { '/ipp.txt' }

      it { is_expected.to contain_file('/ipp.txt') }
    end
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
