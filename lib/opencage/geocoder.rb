require 'opencage/geocoder/location'
require 'opencage/geocoder/request'
require 'open-uri'
require 'json'

module OpenCage
  class Geocoder
    GeocodingError = Class.new(StandardError)

    def initialize(default_options = {})
      @api_key = default_options.fetch(:api_key) { raise GeocodingError, 'missing API key' }
    end

    def geocode(location, options = {})
      request = Request.new(@api_key, location, options)

      results = fetch(request.to_s)
      return [] unless results

      results.map { |r| Location.new(r) }
    end

    def reverse_geocode(lat, lng, options = {})
      lat = Float(lat)
      lng = Float(lng)

      geocode("#{lat},#{lng}", options).first
    end

    private

    def fetch(url)
      JSON.parse(URI(url).open.read)['results']
    rescue OpenURI::HTTPError => error
      raise GeocodingError, error_message(error)
    end

    def error_message(error)
      case String(error)
      when /^403/
        'invalid API key'
      when /^402/
        'out of quota'
      else
        error
      end
    end
  end
end
