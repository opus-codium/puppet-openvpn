require 'spec_helper'

describe 'openvpn::config' do
  let(:title) { 'test' }
  let(:facts) do
    {
      osfamily: osfamily
    }
  end
  let(:params) do
    {
      role: 'server',
      topology: 'subnet',
      server_network: '10.0.0.0',
      server_netmask: '255.0.0.0'
    }
  end

  context 'on Debian' do
    let(:osfamily) { 'Debian' }

    it { is_expected.to contain_concat('/etc/openvpn/test.conf') }
    it { is_expected.to contain_openvpn__service('test') }
  end

  context 'on FreeBSD' do
    let(:osfamily) { 'FreeBSD' }

    it { is_expected.to contain_concat('/usr/local/etc/openvpn/test.conf') }
    it { is_expected.to contain_openvpn__service('test') }
  end
end
