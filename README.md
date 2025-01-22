# OpenCage Geocoder

A Ruby client for the [OpenCage geocoding API](https://opencagedata.com/api).

## Build status / Code quality / etc

[![Build Status](https://github.com/OpenCageData/ruby-opencage-geocoder/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/OpenCageData/ruby-opencage-geocoder/actions/workflows/build.yml)
[![Gem Version](https://badge.fury.io/rb/opencage-geocoder.svg)](https://badge.fury.io/rb/opencage-geocoder)
![Mastodon Follow](https://img.shields.io/mastodon/follow/109287663468501769?domain=https%3A%2F%2Fen.osm.town%2F&style=social)

## Installation

```
gem install opencage-geocoder
```

Or in your Gemfile:

```ruby
source 'https://rubygems.org'
gem 'opencage-geocoder'
```

## Tutorial

You can find a comprehensive [tutorial for using this module on the OpenCage site](https://opencagedata.com/tutorials/geocode-in-ruby).

## API Documentation

Complete documentation for the OpenCage geocoding API can be found at
[opencagedata.com/api](https://opencagedata.com/api).

## Usage

Create an instance of the geocoder, passing a valid OpenCage Geocoder API key:

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
results = geocoder.geocode('Manchester', countrycode: 'CA', language: 'ja')
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
p results.first.geometry # might be empty for some results
p results.first.bounds # might be empty for some results
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
p result.annotations['timezone']
# {"timezone"=>{"name"=>"Africa/Windhoek", "now_in_dst"=>0, "offset_sec"=>7200, "offset_string"=>200, "short_name"=>"CAT"}}
```

### Error handling

The geocoder will return an `OpenCage::Error` subclass if there is a
problem with either input or response, for example:

```ruby
begin
  # Invalid API key
  geocoder =  OpenCage::Geocoder.new(api_key: 'invalid-api-key')
  geocoder.geocode('Manchester')
rescue OpenCage::Error::AuthenticationError => e
  p 'invalid apikey'
rescue OpenCage::Error::QuotaExceeded => e
  p 'over quota'
rescue StandardError => e
  p 'other error: ' + e.message
end

# Using strings instead of numbers for reverse geocoding
geocoder.reverse_geocode('51.5019951', '-0.0698806')
# raises OpenCage::Error::InvalidRequest (not valid numeric coordinates: "51.5019951", "-0.0698806")

begin

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
  latitude, longitude = line.chomp.split(',')

  # Use Float() rather than #to_f because it will throw an ArgumentError if
  # there is an invalid line in the queries.txt file
  result = geocoder.reverse_geocode(Float(latitude), Float(longitude))
  results.push(result)
rescue ArgumentError, OpenCage::Error::GeocodingError => error
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

## Upgrading to version 3.0

- Version 2.x raised `OpenCage::Geocoder`. Now `OpenCage::Error` is raised.

## Upgrading to version 2.0

- Version 0.1x only returned one result

```
geocoder.geocode('Berlin').coordinates # Version 0.12
geocoder.geocode('Berlin').first.coordinates # Version 2

geocoder.reverse_geocode(50, 7).name # Version 0.12
geocoder.reverse_geocode(50, 7).address # Version 2
```

- Version 0.1x raised an error when no result was found. Version 2 returns an empty list (forward) or nil (reverse).

## Copyright

Copyright (c) OpenCage GmbH. See LICENSE for details.

## Who is OpenCage GmbH?

<a href="https://opencagedata.com"><img src="opencage_logo_300_150.png"></a>

We run a worldwide [geocoding API](https://opencagedata.com/api) and [geosearch](https://opencagedata.com/geosearch) service based on open data.
Learn more [about us](https://opencagedata.com/about).

We also run [Geomob](https://thegeomob.com), a series of regular meetups for location based service creators, where we do our best to highlight geoinnovation. If you like geo stuff, you will probably enjoy [the Geomob podcast](https://thegeomob.com/podcast/).
