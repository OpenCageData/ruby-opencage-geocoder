module OpenCage
  class Geocoder
    class Request
      def initialize(api_key, query, options = {})
        @host = options.fetch(:host, 'api.opencagedata.com')
        @params = options.merge(key: api_key, q: query)
      end

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
