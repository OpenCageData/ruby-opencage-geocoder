require File.expand_path '../spec_helper.rb', __dir__

describe OpenCage::Geocoder do
  def geo
    OpenCage::Geocoder.new(api_key: ENV.fetch('OPEN_CAGE_API_KEY'))
  end

  describe 'authentication' do
    it 'raises an error if the API key is missing' do
      expect do
        described_class.new
      end.to raise_error(OpenCage::Error::AuthenticationError)
    end

    it 'raises an error when geocoding if the API key is incorrect', :vcr do
      expect do
        geo = described_class.new(api_key: 'AN-INVALID-KEY')
        geo.geocode('SOMEWHERE')
      end.to raise_error(OpenCage::Error::AuthenticationError)
    end

    it 'raises an error when geocoding if the user is out of quota' do
      # Difficult to force a real 402, so simulate it with WebMock
      stub_request(:get, /api\.opencagedata\.com/)
        .to_return(body: '402 out of quota', status: 402)

      expect do
        geo.geocode('SOMEWHERE')
      end.to raise_error(OpenCage::Error::QuotaExceeded)
    end
  end

  describe '#reverse_geocode' do
    it 'reverse geocodes a set of coordinates', :vcr do
      expect(
        geo.reverse_geocode(51.5019951, -0.0698806).address
      ).to eql('Reeds Wharf, 33 Mill Street, London SE15, United Kingdom')
    end

    it 'set language', :vcr do
      expect(
        geo.reverse_geocode(51.5019951, -0.0698806, language: 'ru').address
      ).to match('Лондон SE15, Великобритания')
    end

    it 'raises an error for non-numeric input' do
      expect do
        geo.reverse_geocode('NOT-A-COORD', 51.50934)
      end.to raise_error(OpenCage::Error::InvalidRequest)
    end
  end

  describe '#geocode' do
    it 'geocodes a place name', :vcr do
      expect(geo.geocode('Mudgee, Australia').first.coordinates).to eql([-32.5980702, 149.5886383])
    end

    it 'geocodes a postcode', :vcr do
      expect(geo.geocode('EC1M 5RF').first.coordinates).to eql([51.522676, -0.102549])
    end

    it 'geocodes a place name with encoding', :vcr do
      expect(geo.geocode('Münster').first.coordinates).to eql([51.9501317, 7.6133017])
    end

    it 'correctly parses a request with encoding in the response', :vcr do
      expect(geo.geocode('Donostia').first.coordinates).to eql([43.3224219, -1.9838889])
    end

    # it 'throws a useful error when no results are found' do
    #   expect do
    #     geo.geocode('NOWHERE-INTERESTING')
    #   end.to raise_error(OpenCage::Geocoder::GeocodingError, 'location not found')
    # end

    it 'empty list when no results are found', :vcr do
      expect(geo.geocode('NOWHERE-INTERESTING')).to eql([])
    end
  end
end
