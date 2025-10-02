require 'opencage/geocoder/location'
require 'opencage/geocoder/request'
require 'opencage/error'
require 'opencage/version'
require 'open-uri'
require 'json'

module OpenCage
  class Geocoder
    def initialize(default_options = {})
      @api_key = default_options.fetch(:api_key) { raise_error('401 Missing API key') }
      @user_agent = default_options.fetch(:user_agent) { "opencage-ruby/#{OpenCage::VERSION} Ruby/#{RUBY_VERSION}" }
    end

    def geocode(location, options = {})
      raise_error("400 Not a valid location: `#{location.inspect}`") unless location.is_a?(String)

      request = Request.new(@api_key, location, options)

      begin
        results = fetch(request.to_s)
      rescue Errno::ECONNREFUSED
        raise_error("408 Failed to open TCP connection to API #{request}")
      rescue Errno::ECONNRESET
        # Connection reset by peer - SSL_connect
        raise_error("408 Failed to open SSL connection to API #{request}")
      rescue Net::OpenTimeout
        raise_error("408 Timeout connecting to API #{request}")
      end

      return [] unless results

      results.map { |r| Location.new(r) }
    end

    def reverse_geocode(lat, lng, options = {})
      begin
        lat = to_float(lat)
        lng = to_float(lng)
      rescue TypeError
        raise_error("400 Not valid numeric coordinates: #{lat.inspect}, #{lng.inspect}")
      end

      if [lat, lng].any? { |coord| !coord.is_a?(Numeric) }
        raise_error("400 Not valid numeric coordinates: #{lat.inspect}, #{lng.inspect}")
      end

      geocode("#{lat},#{lng}", options).first
    end

    private

    def fetch(url)
      JSON.parse(URI(url).open(headers).read)['results']
    rescue OpenURI::HTTPError => e
      raise_error(e)
    end

    def headers
      { 'User-Agent' => @user_agent }
    end

    def raise_error(error)
      code = String(error).slice(0, 3)
      klass = OpenCage::Error::ERRORS[code.to_i]
      raise klass.new(message: String(error), code: code.to_i)
    end

    def to_float(coord)
      Float(coord)
    rescue ArgumentError
      coord
    end
  end
end
