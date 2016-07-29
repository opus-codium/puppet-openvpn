require 'spec_helper'

shared_examples 'simple include' do
  context 'with defaults for all parameters' do
    it { should contain_class('openvpn') }
    it { is_expected.to contain_package('openvpn') }
  end
end

describe 'openvpn' do
  describe 'on Debian GNU/Linux' do
    let(:facts) do
      {
        osfamily: 'Debian',
      }
    end

    include_examples 'simple include'

    it do
      is_expected.to contain_service('openvpn').with(
        ensure: 'stopped',
        enable: 'false',
      )
    end
  end

  describe 'on FreeBSD' do
    let(:facts) do
      {
        osfamily: 'FreeBSD',
      }
    end

    include_examples 'simple include'
  end
end
