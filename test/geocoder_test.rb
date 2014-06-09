# encoding: utf-8

require 'minitest/pride'
require 'minitest/autorun'

require_relative '../lib/opencage/geocoder'

describe OpenCage::Geocoder do
  describe 'authentication' do
    it 'raises an error if the API key is missing' do
      proc {
        OpenCage::Geocoder.new
      }.must_raise OpenCage::Geocoder::GeocodingError
    end

    it 'raises an error when geocoding if the API key is incorrect' do
      proc {
        geo = OpenCage::Geocoder.new(api_key: 'AN-INVALID-KEY')
        geo.geocode('SOMEWHERE')
      }.must_raise OpenCage::Geocoder::GeocodingError
    end
  end

  # Failed fetch


  describe '#geocode' do
    def geo
      OpenCage::Geocoder.new(api_key: ENV.fetch('OPEN_CAGE_API_KEY'))
    end

    it 'geocodes a place name' do
      assert_equal [ -32.5980702, 149.5886383 ], geo.geocode('Mudgee, Australia')
    end

    it 'geocodes a postcode' do
      assert_equal [ 51.5221558691, -0.100838524406 ], geo.geocode('EC1M 5RF')
    end

    it 'geocodes a place name with encoding' do
      assert_equal [ 51.9625101, 7.6251879 ], geo.geocode('Münster')
    end

    it 'correctly parses a request with encoding in the response' do
      assert_equal [ 43.3213324, -1.9856227 ], geo.geocode('Donostia')
    end
  end
end