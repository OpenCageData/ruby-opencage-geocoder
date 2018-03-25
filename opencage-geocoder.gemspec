lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opencage/version'

Gem::Specification.new do |s|
  s.name        = 'opencage-geocoder'
  s.version     = OpenCage::VERSION
  s.licenses    = ['MIT']
  s.summary     = "A client for the OpenCage Data geocoder API"
  s.description = "A client for the OpenCage Data geocoder API - https://geocoder.opencagedata.com/"
  s.authors     = ["Samuel Scully"]
  s.email       = 'support@opencagedata.com'
  s.files       = Dir['lib/**/*.{rb}']
  s.homepage    = 'https://github.com/opencagedata/ruby-opencage-geocoder'
end
