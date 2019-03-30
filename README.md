[![Build Status](https://travis-ci.org/OpenCageData/ruby-opencage-geocoder.svg?branch=master)](https://travis-ci.org/OpenCageData/ruby-opencage-geocoder)
[![Kritika Analysis Status](https://kritika.io/users/freyfogle/repos/3990778871294442/heads/master/status.svg)](https://kritika.io/users/freyfogle/repos/3990778871294442/heads/master/)
[![Gem Version](https://badge.fury.io/rb/opencage-geocoder.svg)](https://badge.fury.io/rb/opencage-geocoder)

# OpenCage Geocoder

A Ruby client for the [OpenCage Data](https://opencagedata.com/) geocoding API.

## Installation

```
gem install opencage-geocoder
```

Or in your Gemfile:

```ruby
source 'https://rubygems.org'
gem 'opencage-geocoder'
```

## Documentation

Complete documentation for the OpenCage geocoding API can be found at
[opencagedata.com/api](https://opencagedata.com/api).

## Usage

Create an instance of the geocoder, passing a valid OpenCage Data Geocoder API key:

```ruby
require 'opencage/geocoder'

geocoder = OpenCage::Geocoder.new(api_key: 'your-api-key-here')
```

### Geocode an address or place name

```ruby
results = geocoder.geocode('82 Clerkenwell Road, London')
p results.first.coordinates
# [ 51.5221558691, -0.100838524406 ]

results = geocoder.geocode('Manchester')
results.each { |res| p res.address }
# "Manchester, Greater Manchester, England, United Kingdom"
# "Manchester, NH, United States of America"
# "Manchester, Jamaica"
# "Manchester, CT 06042, United States of America"
# ...

# We want the city in Canada and results in Japanese
results = geocoder.geocode('Manchester', country_code: 'CA', language: 'ja')
p results.first.address
# "Manchester, ノバスコシア州, カナダ"
p results.first.components
# {
#   "_type" => "city",
#   "city" => "Manchester",
#   "county" => "Guysborough County",
#   "state" => "ノバスコシア州",
#   "state_code" => "NS",
#   "country" => "カナダ",
#   "country_code" => "ca",
#   "ISO_3166-1_alpha-2" => "CA",
#   "ISO_3166-1_alpha-3" => "CAN"
# }

```

### Convert latitude, longitude to an address

```ruby
result = geocoder.reverse_geocode(51.5019951, -0.0698806)
p result.address
# 'Bermondsey Wall West, Bermondsey, London Boro ...

```

### Annotations

See the [API documentation](https://opencagedata.com/api#annotations) for a
complete list of annotations.

```ruby
result = geocoder.reverse_geocode(-22.6792, 14.5272)
p result.annotations['geohash']
# "k7fqfx6h5jbq5tn8tnpn"
```

### Error handling

The geocoder will return an `OpenCage::Geocoder::GeocodingError` if there is a
problem with either input or response, for example:

```ruby
# Invalid API key
geocoder =  OpenCage::Geocoder.new(api_key: 'invalid-api-key')
geocoder.geocode('Manchester')
# OpenCage::Geocoder::GeocodingError (invalid API key)

# Using strings instead of numbers for reverse geocoding
geocoder.reverse_geocode('51.5019951', '-0.0698806')
# OpenCage::Geocoder::GeocodingError (not valid numeric coordinates: "51.5019951", "-0.0698806")
```

### Batch geocoding

Fill a text file `queries.txt` with queries:

```
24.77701,121.02189
31.79261,35.21785
9.54828,44.07715
59.92903,30.32989
```

Then loop through the file:

```ruby
geocoder = OpenCage::Geocoder.new(api_key: 'your-api-key-here')

results = []
File.foreach('queries.txt') do |line|
  lat, lng = line.chomp.split(',')

  # Use Float() rather than #to_f because it will throw an ArgumentError if
  # there is an invalid line in the queries.txt file
  result = geocoder.reverse_geocode(Float(lat), Float(lng))
  results.push(result)
rescue ArgumentError, OpenCage::Geocoder::GeocodingError => error
  # Stop looping through the queries if there is an error
  puts "Error: #{error.message}"
  break
end

puts results.map(&:address)
# 韓國館, 金山十一街, 金山里, Hsinchu 30082, Taiwan
# David Hazan 11, NO Jerusalem, Israel
# هرجيسا, Jameeco Weyn, Hargeisa, Somalia
# Китайское бистро, Apraksin Yard, Михайловский проезд ...
```

## Upgrading from version 0.1x

* Version 0.1x only returned one result

```
geocoder.geocode('Berlin').coordinates # Version 0.12
geocoder.geocode('Berlin').first.coordinates # Version 2

geocoder.reverse_geocode(50, 7).name # Version 0.12
geocoder.reverse_geocode(50, 7).address # Version 2
```

* Version 0.1x raised an error when no result was found. Version 2 returns an empty list (forward) or nil (reverse).


## Copyright

Copyright (c) 2019 OpenCage Data Ltd. See LICENSE for details.
