require 'open-uri'
require 'json'
require 'cgi'

module OpenCage
  class Geocoder
    class Location
      attr_reader :geo

      def initialize(geo, options = {})
        @geo  = geo
        @lat  = options[:lat]
        @lng  = options[:lng]
        @name = options[:name]
      end

      def lat
        @lat ||= results.first['geometry']['lat'].to_f
      end

      def lng
        @lng ||= results.first['geometry']['lng'].to_f
      end

      def name
        @name ||= results.first['formatted']
      end

      def coordinates
        [lat, lng]
      end

      private

      def results
        @results ||= Array(fetch).tap do |results|
          raise GeocodingError, 'location not found' if results.empty?
        end
      end

      def fetch
        JSON.parse(URI(url).open.read)['results']
      rescue OpenURI::HTTPError => error
        raise GeocodingError, error_message(error)
      end

      def url
        uri = URI.parse(geo.url)
        uri.query = [uri.query, "q=#{query}"].join('&')
        uri
      end

      def query
        if @lat && @lng && !@name
          "#{lat},#{lng}"
        elsif @name
          CGI.escape(@name)
        end
      end

      def error_message(error)
        String(error).start_with?('403') ? 'invalid API key' : error
      end
    end
  end
end
