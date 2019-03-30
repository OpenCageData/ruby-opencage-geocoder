require File.expand_path '../lib/opencage/geocoder', __dir__
require 'rspec'
require 'vcr'

THIRTY_DAYS = 30 * 24 * 60 * 60

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<OPEN_CAGE_API_KEY>') { ENV.fetch('OPEN_CAGE_API_KEY') }
end
