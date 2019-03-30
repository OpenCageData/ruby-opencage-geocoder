# Contributing to OpenCage Geocoder

## Introduction

Thank you for considering contributing to ruby-opencage-geocoder. When
contributing, please discuss the change you wish to make via issues first.

To contribute, make a fork of the repository and a branch for your change. Make
your changes to your fork then submit a pull request.

## Running the tests

First install the development dependencies:

```
bundle install
```

Then run the test suite using rspec:

```
rspec
```

We use the [VCR gem](https://github.com/vcr/vcr) to record HTTP requests to the
OpenCage API. If you add a test that makes an HTTP request you will need to tag
it with the `:vcr` tag, for example:

```ruby
it 'geocodes a place name', :vcr do
  expect(geo.geocode('Mudgee, Australia').first.coordinates).to eql([-32.5980702, 149.5886383])
end
```

If the OpenCage API has changed and VCR cassettes need updating, you can refresh
them as follows:

```
rm -r spec/cassettes
OPEN_CAGE_API_KEY=<YOUR_API_KEY> rspec
```

You will need an OpenCage API key, which you can get by signing up at
[opencagedata.com](https://opencagedata.com/). The free tier request quota
will be more than enough to run the test suite.
