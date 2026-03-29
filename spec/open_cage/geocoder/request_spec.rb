# frozen_string_literal: true

require File.expand_path '../../spec_helper.rb', __dir__

describe OpenCage::Geocoder::Request do
  let(:api_key) { '1111222233334444' }

  it 'creates a URI instance' do
    expect(described_class.new(api_key, 'New York').url).to be_a(URI::HTTPS)
  end

  it 'forward' do
    expect(described_class.new(api_key, 'New York').to_s).to eql('https://api.opencagedata.com/geocode/v1/json?key=1111222233334444&q=New+York')
  end

  describe 'host validation' do
    valid = %w[
      api.opencagedata.com
      api2.opencagedata.com
      localhost
      localhost:3000
      127.0.0.1
      127.0.0.1:8080
      0.0.0.0
      0.0.0.0:443
      ::1
    ]
    valid.each do |host|
      it "allows #{host}" do
        expect { described_class.new(api_key, 'q', host: host) }.not_to raise_error
      end
    end

    invalid = %w[
      example.com
      opencagedata.com.example.com
      notopencagedata.com
    ]
    invalid.each do |host|
      it "rejects #{host}" do
        expect { described_class.new(api_key, 'q', host: host) }.to raise_error(ArgumentError, /Invalid host/)
      end
    end
  end
end
