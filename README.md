# OpenCage Geocoder

A ruby client for the [OpenCage Data](http://www.opencagedata.com/)
geocoder API.

## Usage

```
$ gem install opencage-geocoder
```

Or in your Gemfile:

```ruby
source 'https://rubygems.org'

gem 'opencage-geocoder'
```

Create an instance of the geocoder, passing a valid OpenCage Data Geocoder API key:

```ruby
require 'opencage/geocoder'

geocoder = OpenCage::Geocoder.new(api_key: 'your-api-key-here')
```

Pass a string containing the query or address to be geocoded to the `geocode` method:

```ruby
geocoder.geocode("82 Clerkenwell Road, London")
# => [ 51.5221558691, -0.100838524406 ]
```

You can also `reverse_geocode` to get an address from a pair of coordinates:

```ruby
geocoder.reverse_geocode(51.5019951, -0.0698806)
# => 'Bermondsey Wall West, Bermondsey, London Boro ...

# input type is flexible
geocoder.reverse_geocode([51.5019951, '-0.0698806'])
# => 'Bermondsey Wall West, Bermondsey, London Boro ...
```