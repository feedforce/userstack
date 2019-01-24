# frozen_string_literal: true

describe Userstack::UriBuilder do
  describe '.execute' do
    subject { Userstack::UriBuilder.execute(access_key, useragent, use_ssl, legacy) }

    let(:access_key) { 'c22b52f2b1409beb22585ae658280' }
    let(:useragent) { 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36' }
    let(:use_ssl) { true }
    let(:legacy) { false }

    shared_examples_for 'Userstack::UriBuilder' do
      it 'has Userstack host' do
        expect(subject.host).to eq 'api.userstack.com'
      end

      it 'has `/detect` path' do
        expect(subject.path).to eq '/detect'
      end
    end

    shared_examples_for 'Userstack::UriBuilder HTTPS' do
      it { is_expected.to be_an_instance_of URI::HTTPS }

      it 'has https scheme' do
        expect(subject.scheme).to eq 'https'
      end
    end

    shared_examples_for 'Userstack::UriBuilder HTTP' do
      it { is_expected.to be_an_instance_of URI::HTTP }

      it 'has http scheme' do
        expect(subject.scheme).to eq 'http'
      end
    end

    context 'default' do
      it_behaves_like 'Userstack::UriBuilder'
      it_behaves_like 'Userstack::UriBuilder HTTPS'

      it 'has encoded query' do
        expect(subject.query).to eq(
          'access_key=c22b52f2b1409beb22585ae658280&'\
          'ua=Mozilla%2F5.0+%28Macintosh%3B+Intel+Mac+'\
          'OS+X+10_12_3%29+AppleWebKit%2F537.36+%28KHTML%2C+'\
          'like+Gecko%29+Chrome%2F56.0.2924.87+Safari%2F537.36'
        )
      end
    end

    context 'use_ssl is false' do
      let(:use_ssl) { false }

      it_behaves_like 'Userstack::UriBuilder'
      it_behaves_like 'Userstack::UriBuilder HTTP'

      it 'has encoded query' do
        expect(subject.query).to eq(
          'access_key=c22b52f2b1409beb22585ae658280&'\
          'ua=Mozilla%2F5.0+%28Macintosh%3B+Intel+Mac+'\
          'OS+X+10_12_3%29+AppleWebKit%2F537.36+%28KHTML%2C+'\
          'like+Gecko%29+Chrome%2F56.0.2924.87+Safari%2F537.36'
        )
      end
    end

    context 'legacy is true' do
      let(:legacy) { true }

      it_behaves_like 'Userstack::UriBuilder'
      it_behaves_like 'Userstack::UriBuilder HTTPS'

      it 'has encoded query which include legacy params' do
        expect(subject.query).to eq(
          'access_key=c22b52f2b1409beb22585ae658280&'\
          'ua=Mozilla%2F5.0+%28Macintosh%3B+Intel+Mac+'\
          'OS+X+10_12_3%29+AppleWebKit%2F537.36+%28KHTML%2C+'\
          'like+Gecko%29+Chrome%2F56.0.2924.87+Safari%2F537.36'\
          '&legacy=1'
        )
      end
    end
  end
end
