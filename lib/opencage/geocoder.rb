require 'opencage/geocoder/location'

module OpenCage
  class Geocoder
    GeocodingError = Class.new(StandardError)

    BASE_URL = 'http://api.opencagedata.com/geocode/v1/json'.freeze

    attr_reader :api_key

    def initialize(options = {})
      @api_key = options.fetch(:api_key) { raise GeocodingError.new('missing API key') }
    end

    def geocode(location)
      Location.new(self, name: location).coordinates
    end

    def reverse_geocode(*coordinates)
      # Accept input as numbers, strings or an array. Raise an error
      # for anything that cannot be interpreted as a pair of floats.
      lat, lng = coordinates.flatten.compact.map { |coord| Float(coord) }

      Location.new(self, lat: lat, lng: lng).name
    end

    def url
      "#{BASE_URL}?key=#{api_key}"
    end
  end
end
