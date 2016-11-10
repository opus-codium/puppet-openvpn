require 'spec_helper'

describe 'openvpn::server' do
  let(:title) { 'main' }
  let(:params) do
    {
      server: '192.168.0.0',
      netmask: '255.255.255.0',
      ta: ta,
      ta_content: ta_content,
    }
  end
  let(:facts) do
    {
      osfamily: 'Debian',
    }
  end
  let(:ta) { :undef }
  let(:ta_content) { :undef }

  it do
    is_expected.to contain_openvpn__config('main').with(
      server: '192.168.0.0',
      netmask: '255.255.255.0',
    )
  end

  describe 'tls auth file' do
    let(:ta) { true }

    describe 'generated' do
      it { is_expected.to contain_exec('/usr/sbin/openvpn --genkey --secret "/etc/openvpn/main-ta.key"') }
      it { is_expected.to contain_file('/etc/openvpn/main-ta.key') }
    end

    describe 'passed' do
      let(:ta_content) { 'bloub' }

      it { is_expected.to contain_file('/etc/openvpn/main-ta.key').with(content: 'bloub') }
    end
  end
end
