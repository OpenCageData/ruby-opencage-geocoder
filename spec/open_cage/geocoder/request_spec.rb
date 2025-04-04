require File.expand_path '../../spec_helper.rb', __dir__

describe OpenCage::Geocoder::Request do
  let(:api_key) { '1111222233334444' }

  it 'creates a URI instance' do
    expect(described_class.new(api_key, 'New York').url).to be_a(URI::HTTPS)
  end

  it 'forward' do
    expect(described_class.new(api_key, 'New York').to_s).to eql('https://api.opencagedata.com/geocode/v1/json?key=1111222233334444&q=New+York')
  end
end
