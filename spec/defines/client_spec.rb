require 'spec_helper'

describe 'openvpn::client' do
  let(:title) { 'client' }
  let(:params) do
    {
      remote: '203.0.113.27',
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
    is_expected.to contain_openvpn__config('client').with(
      remote: '203.0.113.27',
    )
  end

  describe 'tls auth file' do
    describe 'enabled' do
      let(:ta) { true }
      describe 'with content' do
        let(:ta_content) { 'bloub' }

        it { is_expected.to contain_file('/etc/openvpn/client-ta.pem').with(content: 'bloub') }
      end

      describe 'without content' do
        it { is_expected.to compile.and_raise_error(/Enabling 'ta' requires setting 'ta_content' too./) }
      end
    end
  end
end
