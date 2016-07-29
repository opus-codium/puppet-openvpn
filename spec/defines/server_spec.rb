require 'spec_helper'

describe 'openvpn::server' do
  let(:title) { 'main' }
  let(:params) do
    {
      server: '192.168.0.0',
      netmask: '255.255.255.0',
    }
  end
  let(:facts) do
    {
      osfamily: 'Debian',
    }
  end
  it do
    is_expected.to contain_openvpn__config('main').with(
      server: '192.168.0.0',
      netmask: '255.255.255.0',
    )
  end
end
