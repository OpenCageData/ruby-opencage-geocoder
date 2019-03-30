require File.expand_path 'spec_helper.rb', __dir__

describe OpenCage::Geocoder::Location do
  subject do
    geocoder = OpenCage::Geocoder.new(api_key: ENV.fetch('OPEN_CAGE_API_KEY'))
    geocoder.reverse_geocode(-22.6792, 14.5272)
  end

  it 'has components', :vcr do
    expect(subject.components['continent']).to eq('Africa')
    expect(subject.components['state']).to eq('Erongo Region')
  end

  it 'has annotations', :vcr do
    expect(subject.annotations['geohash']).to eq('k7fqfx6h5jbq5tn8tnpn')
    expect(subject.annotations['DMS']['lat']).to eq("22° 40' 45.05736'' S")
  end

  it 'has confidence', :vcr do
    expect(subject.confidence).to eq(9)
  end
end
