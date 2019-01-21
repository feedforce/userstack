# frozen_string_literal: true

require 'json'
require 'net/https'

module Userstack
  # A class which wraps calls to Userstack API
  class Client
    USER_AGENT = 'Userstack gem/%s' % VERSION
    private_constant :USER_AGENT

    # @param access_key [String] Userstack Access key
    # @param use_ssl [Boolean] Use ssl or not
    # @param legacy [Boolean] Legacy response
    # @raise [ArgumentError] when `access_key` is invalid
    # @see https://userstack.com/documentation
    def initialize(access_key, use_ssl: true, legacy: false)
      raise ArgumentError, 'Invalid Access key' if access_key.nil? || access_key.empty?

      @access_key = access_key.freeze
      @use_ssl = use_ssl
      @legacy = legacy
      freeze
    end

    # Parse an useragent using Userstack
    #
    # @param useragent [String] an useragent
    # @return [Hash] a Hash generated by parsing the JSON returned
    #   from the API call, just `{}` on parsing failure
    # @raise [ArgumentError] when `useragent` is invalid
    def parse(useragent)
      raise ArgumentError, 'Invalid useragent' if useragent.nil? || useragent.empty?

      response = request(useragent)
      parse_as_json(response.body)
    end

    private

    attr_reader :access_key, :use_ssl, :legacy

    def request(useragent)
      uri = Userstack::UriBuilder.execute(access_key, useragent, use_ssl, legacy)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.get(uri.to_s, 'User-Agent' => USER_AGENT)
      end
    end

    def parse_as_json(json_text)
      json_text ||= '{}'
      JSON.parse(json_text)
    rescue JSON::ParserError
      {}
    end
  end
end
