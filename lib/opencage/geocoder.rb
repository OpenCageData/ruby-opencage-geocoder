require 'opencage/geocoder/location'
require 'opencage/geocoder/request'
require 'opencage/error'
require 'open-uri'
require 'json'

module OpenCage
  class Geocoder
    def initialize(default_options = {})
      @api_key = default_options.fetch(:api_key) { raise_error('401 Missing API key') }
    end

    def geocode(location, options = {})
      request = Request.new(@api_key, location, options)

      results = fetch(request.to_s)
      return [] unless results

      results.map { |r| Location.new(r) }
    end

    def reverse_geocode(lat, lng, options = {})
      if [lat, lng].any? { |coord| !coord.is_a?(Numeric) }
        raise_error("400 Not valid numeric coordinates: #{lat.inspect}, #{lng.inspect}")
      end

      geocode("#{lat},#{lng}", options).first
    end

    private

    def fetch(url)
      JSON.parse(URI(url).open.read)['results']
    rescue OpenURI::HTTPError => e
      raise_error(e)
    end

    def raise_error(error)
      code = String(error).slice(0, 3)
      klass = OpenCage::Error::ERRORS[code.to_i]
      raise klass.new(message: String(error), code: code.to_i)
    end
  end
end
