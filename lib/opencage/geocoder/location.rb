require 'open-uri'
require 'json'

module OpenCage
  class Geocoder
    class Location
      attr_reader :name, :geo

      def initialize(name, geo)
        @name, @geo = name, geo
      end

      def coordinates
        @coordinates ||= [response['lat'], response['lng']].map(&:to_f)
      end

      private

      def response
        @response ||= JSON.parse(fetch)['results'][0]['geometry']
      end

      def fetch
        open(url).read
      rescue OpenURI::HTTPError => error
        raise OpenCage::Geocoder::GeocodingError.new(error_message(error))
      end

      def url
        uri = URI.parse(geo.url)
        uri.query = [uri.query, "q=#{URI::encode(name)}"].join('&')
        uri
      end

      def error_message(error)
        (String(error) =~ /\A403/) ? 'Invalid API key' : error
      end
    end
  end
end
