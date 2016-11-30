require 'spec_helper'

describe 'openvpn::service' do
  let(:title) { 'test' }
  let(:facts) do
    {
      osfamily: osfamily
    }
  end

  context 'on Debian' do
    let(:osfamily) { 'Debian' }

    it { is_expected.to contain_service('openvpn-test') }
  end

  context 'on FreeBSD' do
    let(:osfamily) { 'FreeBSD' }

    it { is_expected.to contain_service('test') }
  end
end
