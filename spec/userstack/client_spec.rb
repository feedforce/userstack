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
  end

  describe '#parse' do
    shared_examples_for 'Userstack' do
      let(:request_uri) { "#{stub_request_uri_scheme}://api.userstack.com/detect?access_key=#{access_key}&ua=#{CGI.escape(useragent)}" }

      before do
        stub_request(:get, request_uri).to_return(status: stub_response_status, body: stub_response_body)
      end

      subject { client.parse(useragent) }
      it { is_expected.to match_array expectation }
    end

    let(:access_key) { 'c22b52f2b1409beb22585ae658280' }
    let(:useragent) { 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36' }
    let(:normal_response) do
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
    let(:legacy_response) do
      {
        'data' => {
          'ua_type' => 'Desktop',
          'os_name' => 'macOS',
          'os_version' => '10.12.3',
          'browser_name' => 'Chrome',
          'browser_version' => '56.0.2924.87',
          'engine_name' => 'WebKit',
          'engine_version' => '537.36',
        }
      }
    end

    context 'given registered Access key' do
      let(:client) { Userstack::Client.new(access_key) }
      let(:stub_request_uri_scheme) { 'https' }
      let(:stub_response_status) { 200 }
      let(:stub_response_body) { normal_response.to_json }
      let(:expectation) { normal_response }

      it_behaves_like 'Userstack'
    end

    context 'given unregistered Access key' do
      let(:client) { Userstack::Client.new(access_key) }
      let(:access_key) { 'unregistered' }
      let(:stub_request_uri_scheme) { 'https' }
      let(:stub_response_status) { 400 }
      let(:stub_response_body) { expectation.to_json }
      let(:expectation) do
        {
          'error' => {
            'code' => 'key_invalid',
            'message' => 'Access Key Invalid'
          }
        }
      end

      it_behaves_like 'Userstack'
    end

    context 'given unclassified Useragent' do
      let(:client) { Userstack::Client.new(access_key) }
      let(:stub_request_uri_scheme) { 'https' }
      let(:stub_response_status) { 200 }
      let(:stub_response_body) { expectation.to_json }
      let(:expectation) do
        {
          'error' => {
            'code' => 'useragent_not_found',
            'message' => 'Useragent Not Found'
          }
        }
      end
      let(:useragent) { 'Excel/15.0' }

      it_behaves_like 'Userstack'
    end

    context 'when a server returns a broken response' do
      let(:client) { Userstack::Client.new(access_key) }
      let(:stub_request_uri_scheme) { 'https' }
      let(:stub_response_status) { 500 }
      let(:stub_response_body) { '<b>Fatal error</b>' }
      let(:expectation) { {} }

      it_behaves_like 'Userstack'
    end

    context 'use http request' do
      let(:client) { Userstack::Client.new(access_key, use_ssl: false) }
      let(:stub_request_uri_scheme) { 'http' }
      let(:stub_response_status) { 200 }
      let(:stub_response_body) { normal_response.to_json }
      let(:expectation) { normal_response }

      it_behaves_like 'Userstack'
    end
  end
end
