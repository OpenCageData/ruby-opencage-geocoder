require File.expand_path '../../spec_helper.rb', __dir__

describe OpenCage::Geocoder::Location do
  let(:reverse_result) do
    geocoder = OpenCage::Geocoder.new(api_key: ENV.fetch('OPEN_CAGE_API_KEY'))
    geocoder.reverse_geocode(-22.6792, 14.5272)
  end

  it 'has components', :vcr do
    expect(reverse_result.components['continent']).to eq('Africa')
    expect(reverse_result.components['state']).to eq('Erongo Region')
  end

  it 'has annotations', :vcr do
    expect(reverse_result.annotations['geohash']).to eq('k7fqfx6h5jbq5tn8tnpn')
    expect(reverse_result.annotations['DMS']['lat']).to eq("22° 40' 45.05736'' S")
  end

  it 'has confidence', :vcr do
    expect(reverse_result.confidence).to eq(9)
  end

  it 'has coordinates, latitude, longitude', :vcr do
    expect(reverse_result.coordinates).to eq([-22.6791826, 14.5268016])

    expect(reverse_result.lat).to eq(-22.6791826)
    expect(reverse_result.lng).to eq(14.5268016)
  end

  it 'has bounds', :vcr do
    expect(reverse_result.bounds).to eq({ 'northeast' => { 'lat' => -22.6791326, 'lng' => 14.5268516 },
                                          'southwest' => { 'lat' => -22.6792326, 'lng' => 14.5267516 } })
  end
end
