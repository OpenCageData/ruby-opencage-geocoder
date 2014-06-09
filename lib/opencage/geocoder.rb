require_relative 'geocoder/location'

module OpenCage
  class Geocoder
    GeocodingError = Class.new(StandardError)

    BASE_URL = "http://api.opencagedata.com/geocode/v1/json"

    attr_reader :api_key

    def initialize(options={})
      @api_key = options.fetch(:api_key) { raise GeocodingError.new('Missing API key') }
    end

    def geocode(location)
      Location.new(location, self).coordinates
    end

    def url
      "#{BASE_URL}?key=#{api_key}"
    end
  end
end