require 'spec_helper'
describe 'openvpn' do

  context 'with defaults for all parameters' do
    it { should contain_class('openvpn') }
  end
end
