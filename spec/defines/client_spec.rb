require 'spec_helper'

describe 'openvpn::client' do
  let(:title) { 'client' }
  let(:params) do
    {
      remote: '203.0.113.27',
    }
  end
  let(:facts) do
    {
      osfamily: 'Debian',
    }
  end
  it do
    is_expected.to contain_openvpn__config('client').with(
      remote: '203.0.113.27',
    )
  end
end
