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
      let(:request_uri) { "#{stub_uri_scheme}://api.userstack.com/detect?access_key=#{access_key}&ua=#{CGI.escape(useragent)}" }

      before do
        stub_request(:get, request_uri).to_return(
          status: stub_status, body: stub_body
        )
      end

      subject { client.parse(useragent) }
      it { is_expected.to match_array expectation }
    end

    let(:access_key) { 'c22b52f2b1409beb22585ae658280' }
    let(:useragent) { 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36' }

    context 'given registered Access key' do
      let(:client) { Userstack::Client.new(access_key) }
      let(:stub_uri_scheme) { 'https' }
      let(:stub_status) { 200 }
      let(:stub_body) { expectation.to_json }
      let(:expectation) do
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

      it_behaves_like 'Userstack'
    end

    context 'given unregistered Access key' do
      let(:client) { Userstack::Client.new(access_key) }
      let(:access_key) { 'unregistered' }
      let(:stub_uri_scheme) { 'https' }
      let(:stub_status) { 400 }
      let(:stub_body) { expectation.to_json }
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
      let(:stub_uri_scheme) { 'https' }
      let(:stub_status) { 200 }
      let(:stub_body) { expectation.to_json }
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
      let(:stub_uri_scheme) { 'https' }
      let(:stub_status) { 500 }
      let(:stub_body) { '<b>Fatal error</b>' }
      let(:expectation) { {} }

      it_behaves_like 'Userstack'
    end

    context 'use http request' do
      let(:client) { Userstack::Client.new(access_key, use_ssl: false) }
      let(:stub_uri_scheme) { 'http' }
      let(:stub_status) { 200 }
      let(:stub_body) { expectation.to_json }
      let(:expectation) do
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

      it_behaves_like 'Userstack'
    end
  end
end
