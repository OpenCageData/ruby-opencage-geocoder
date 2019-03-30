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

# We want the city in Canada and results in Japanease
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
