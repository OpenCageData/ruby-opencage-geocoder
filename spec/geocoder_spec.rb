require File.expand_path 'spec_helper.rb', __dir__

describe OpenCage::Geocoder do
  def geo
    OpenCage::Geocoder.new(api_key: ENV.fetch('OPEN_CAGE_API_KEY'))
  end

  describe 'authentication' do
    it 'raises an error if the API key is missing' do
      expect do
        OpenCage::Geocoder.new
      end.to raise_error(OpenCage::Geocoder::GeocodingError)
    end

    it 'raises an error when geocoding if the API key is incorrect' do
      expect do
        geo = OpenCage::Geocoder.new(api_key: 'AN-INVALID-KEY')
        geo.geocode('SOMEWHERE')
      end.to raise_error(OpenCage::Geocoder::GeocodingError)
    end
  end

  describe '#reverse_geocode' do
    def bermondsey
      'Reeds Wharf, 33 Mill Street, London SE15, United Kingdom'
    end

    it 'reverse geocodes a set of coordinates' do
      expect(geo.reverse_geocode(51.5019951, -0.0698806)).to eql(bermondsey)
    end

    it 'accepts arrays and strings for coordinates' do
      expect(geo.reverse_geocode([51.5019951, '-0.0698806'])).to eql(bermondsey)
    end

    it 'is simple to handle a single string' do
      expect(geo.reverse_geocode('51.5019951 -0.0698806'.split)).to eql(bermondsey)
    end

    it 'raises an error for badly formed input' do
      expect do
        geo.reverse_geocode('NOT-A-COORD', 51.50934)
      end.to raise_error('invalid value for Float(): "NOT-A-COORD"')
    end
  end

  describe '#geocode' do
    it 'geocodes a place name' do
      expect(geo.geocode('Mudgee, Australia')).to eql([-32.5980702, 149.5886383])
    end

    it 'geocodes a postcode' do
      expect(geo.geocode('EC1M 5RF')).to eql([51.5226765, -0.102549])
    end

    it 'geocodes a place name with encoding' do
      expect(geo.geocode('Münster')).to eql([51.9501317, 7.6133017])
    end

    it 'correctly parses a request with encoding in the response' do
      expect(geo.geocode('Donostia')).to eql([43.3224219, -1.9838889])
    end

    it 'throws a useful error when no results are found' do
      expect do
        geo.geocode('NOWHERE-INTERESTING')
      end.to raise_error(OpenCage::Geocoder::GeocodingError)

      expect do
        geo.geocode('NOWHERE-INTERESTING')
      end.to raise_error('location not found')
    end
  end
end
