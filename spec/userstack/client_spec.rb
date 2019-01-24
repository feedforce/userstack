# frozen_string_literal: true

describe Userstack::Client do
  describe '#initialize' do
    let(:client) { Userstack::Client.new(access_key) }

    context 'given valid Access key' do
      let(:access_key) { 'c22b52f2b1409beb22585ae658280' }
      it { expect(client).to be_an_instance_of Userstack::Client }
    end

    context 'given invalid Access key' do
      let(:access_key) { '' }
      it { expect { client }.to raise_error ArgumentError }
    end

    context 'Access key is nil' do
      let(:access_key) { nil }
      it { expect { client }.to raise_error ArgumentError }
    end
  end

  describe '#parse' do
    let(:client) { Userstack::Client.new(access_key) }
    let(:access_key) { 'c22b52f2b1409beb22585ae658280' }
    let(:useragent) { 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36' }
    let(:request_uri) { "https://api.userstack.com/detect?access_key=#{access_key}&ua=#{CGI.escape(useragent)}" }

    before do
      allow(Userstack::UriBuilder).to receive(:execute).and_return(URI(request_uri))
      stub_request(:get, request_uri).to_return(status: response_status, body: response_body)
    end

    context 'Request valid response' do
      let(:response_status) { 200 }
      let(:response_body) { expectation.to_json }
      let(:expectation) do
        {
          'ua' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36',
          'type' => 'browser',
          'brand' => 'Apple',
          'name' => 'Mac',
          'url' => 'https://www.google.com/about/company/',
          'os' => {
            'name' => 'macOS 10.14 Mojave',
            'code' => 'macos_10_14',
            'url' => 'https://en.wikipedia.org/wiki/MacOS_Mojave',
            'family' => 'macOS',
            'family_code' => 'macos',
            'family_vendor' => 'Apple Inc.',
            'icon' => 'https://assets.userstack.com/icon/os/macosx.png',
            'icon_large' => 'https://assets.userstack.com/icon/os/macosx_big.png'
          },
          'device' => {
            'is_mobile_device' => false,
            'type' => 'desktop',
            'brand' => 'Apple',
            'brand_code' => 'apple',
            'brand_url' => 'http://www.apple.com/',
            'name' => 'Mac'
          },
          'browser' => {
            'name' => 'Chrome',
            'version' => '71.0.3578.98',
            'version_major' => '71',
            'engine' => 'WebKit/Blink'
          },
          'crawler' => {
            'is_crawler' => false,
            'category' => nil,
            'last_seen' => nil
          }
        }
      end

      it 'returns normal response' do
        expect(client.parse(useragent)).to match_array expectation
      end

      context 'useragent is empty' do
        it { expect { client.parse('') }.to raise_error ArgumentError }
      end

      context 'useragent is nil' do
        it { expect { client.parse(nil) }.to raise_error ArgumentError }
      end
    end

    context 'when a server returns a broken response' do
      let(:response_status) { 500 }
      let(:response_body) { '<b>Fatal error</b>' }

      it 'returns empty hash response' do
        expect(client.parse(useragent)).to match_array({})
      end
    end
  end
end
