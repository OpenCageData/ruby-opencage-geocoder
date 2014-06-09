# OpenCage Geocoder

A Ruby gem that uses [OpenCage Data's](http://www.opencagedata.com/)
geocoder.

## Usage

Load the module:

```ruby
require 'opencage/geocoder'
```

Create an instance of the geocoder, passing a valid OpenCage Data Geocoder API key
as a parameter:

```ruby
key = 'your-api-key-here'
geocoder = OpenCage::Geocoder.new(api_key: key)
```

Pass a string containing the query or address to be geocoded to the modules's `geocode` method:

```ruby
geocoder.geocode("82 Clerkenwell Road, London")
# => [ 51.5221558691, -0.100838524406 ]
```

You can also reverse geocode to get an address from a pair of coordinates:

```ruby
geocoder.reverse_geocode(51.5019951, -0.0698806)
# => 'Bermondsey Wall West, Bermondsey, London Boro ...
```

The input type is flexible:

```ruby
geocoder.reverse_geocode([51.5019951, -0.0698806])
# => 'Bermondsey Wall West, Bermondsey, London Boro ...

geocoder.reverse_geocode(51.5019951, '-0.0698806')
# => 'Bermondsey Wall West, Bermondsey, London Boro ...
```