# encoding: utf-8

require 'minitest/pride'
require 'minitest/autorun'

require_relative '../lib/opencage/geocoder'

describe OpenCage::Geocoder do
  def geo
    OpenCage::Geocoder.new(api_key: ENV.fetch('OPEN_CAGE_API_KEY'))
  end

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

  describe '#reverse_geocode' do
    def bermondsey
      'Bermondsey Wall West, Bermondsey, London Borough of Southwark, London, SE14, Greater London, England, United Kingdom, gb, London Borough of Southwark'
    end

    it 'reverse geocodes a set of coordinates' do
      assert_equal bermondsey, geo.reverse_geocode(51.5019951, -0.0698806)
    end

    it 'accepts arrays and strings for coordinates' do
      assert_equal bermondsey, geo.reverse_geocode([51.5019951, '-0.0698806'])
    end

    it 'is simple to handle a single string' do
      assert_equal bermondsey, geo.reverse_geocode('51.5019951 -0.0698806'.split)
    end

    it 'raises an error for badly formed input' do
      exception = proc {
        geo.reverse_geocode('NOT-A-COORD', 51.50934)
      }.must_raise ArgumentError
      assert_equal 'invalid value for Float(): "NOT-A-COORD"', exception.message
    end
  end

  describe '#geocode' do
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

    it 'throws a useful error when no results are found' do
      exception = proc {
        geo.geocode('NOWHERE-INTERESTING')
      }.must_raise OpenCage::Geocoder::GeocodingError
      assert_equal exception.message, 'location not found'
    end
  end
end