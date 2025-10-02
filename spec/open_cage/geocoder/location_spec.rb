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
    expect(reverse_result.annotations['geohash']).to eq('k7fqfx67u7m1bew3kzh3')
    expect(reverse_result.annotations['DMS']['lat']).to eq("22° 40' 45.26256'' S")
  end

  it 'has confidence', :vcr do
    expect(reverse_result.confidence).to eq(9)
  end

  it 'has coordinates, latitude, longitude', :vcr do
    expect(reverse_result.coordinates).to eq([-22.6792396, 14.5272048])

    expect(reverse_result.lat).to eq(-22.6792396)
    expect(reverse_result.lng).to eq(14.5272048)

    expect(reverse_result.latitude).to eq(-22.6792396)
    expect(reverse_result.longitude).to eq(14.5272048)
  end

  it 'has bounds', :vcr do
    expect(reverse_result.bounds).to eq({ 'northeast' => { 'lat' => -22.6791681, 'lng' => 14.5277944 },
                                          'southwest' => { 'lat' => -22.6793015, 'lng' => 14.5266951 } })
  end
end
