# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opencage/version'

Gem::Specification.new do |s|
  s.name                  = 'opencage-geocoder'
  s.version               = OpenCage::VERSION
  s.required_ruby_version = '>= 3.2'
  s.licenses              = ['MIT']
  s.summary               = 'A client for the OpenCage geocoder API'
  s.description           = 'A client for the OpenCage geocoding API - https://opencagedata.com/'
  s.authors               = ['Samuel Scully', 'Marc Tobias']
  s.email                 = 'support@opencagedata.com'
  s.files                 = Dir['lib/**/*.{rb}']
  s.homepage              = 'https://opencagedata.com/tutorials/geocode-in-ruby'
  s.metadata              = { 'source_code_uri' => 'https://github.com/opencagedata/ruby-opencage-geocoder',
                              'changelog_uri' => 'https://github.com/opencagedata/ruby-opencage-geocoder/blob/master/CHANGES.txt',
                              'bug_tracker_uri' => 'https://github.com/opencagedata/ruby-opencage-geocoder/issues',
                              'homepage_uri' => 'https://opencagedata.com/tutorials/geocode-in-ruby',
                              'rubygems_mfa_required' => 'true' }
end
