# frozen_string_literal: true

module OpenCage
  class Geocoder
    class Request
      LOCALHOST_HOSTS = %w[localhost 127.0.0.1 0.0.0.0 ::1 [::1]].freeze

      def initialize(api_key, query, options = {})
        @host = options.fetch(:host, 'api.opencagedata.com')
        validate_host!(@host)
        @params = options.merge(key: api_key, q: query)
      end

      private

      def validate_host!(host)
        hostname = host.to_s.downcase.gsub(/(?<=\w):\d+\z/, '')
        return if hostname.end_with?('.opencagedata.com')
        return if LOCALHOST_HOSTS.include?(hostname)

        raise ArgumentError, "Invalid host: #{host}. Must be a subdomain of opencagedata.com or localhost."
      end

      public

      def url
        uri = URI::HTTPS.build(host: @host, path: '/geocode/v1/json')
        uri.query = URI.encode_www_form(@params)
        uri
      end

      def to_s
        url.to_s
      end
    end
  end
end
