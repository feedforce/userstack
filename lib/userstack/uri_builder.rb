# frozen_string_literal: true

require 'cgi'

module Userstack
  # A class which builds uri of Userstack api
  class UriBuilder
    USERSTACK_API_DOMAIN = 'api.userstack.com'
    private_constant :USERSTACK_API_DOMAIN

    private_class_method :new

    # @param access_key [String] Userstack Access key
    # @param useragent [String] useragent
    # @param use_ssl [Boolean] Use ssl or not
    # @param legacy [Boolean] Legacy response
    # @return [URI::HTTP, URI::HTTPS]
    def self.execute(access_key, useragent, use_ssl, legacy)
      new(access_key, useragent, use_ssl, legacy).send(:execute)
    end

    private

    attr_reader :access_key, :useragent, :use_ssl, :legacy

    def initialize(access_key, useragent, use_ssl, legacy)
      @access_key = access_key.freeze
      @useragent = useragent.freeze
      @use_ssl = use_ssl
      @legacy = legacy
      freeze
    end

    def execute
      fqdn = URI("#{scheme}://#{USERSTACK_API_DOMAIN}/")
      fqdn.dup.tap do |uri|
        uri.path = '/detect'
        uri.query = request_query
      end
    end

    def request_query
      query = {
        access_key: access_key,
        ua: CGI.escape(useragent)
      }
      query[:legacy] = 1 if legacy
      query.map { |k, v| "#{k}=#{v}" }.join('&')
    end

    def scheme
      use_ssl ? 'https' : 'http'
    end
  end
end
