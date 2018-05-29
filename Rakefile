##
# Initialise Bundler, catch errors.
##
require 'bundler'
require 'bundler/gem_tasks'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems.'
  exit e.status_code
end

##
# Configure the test suite.
##
require 'rake/testtask'
require 'rspec/autorun'

Rake::TestTask.new :spec do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
end

##
# By default, just run the tests.
##
task default: :spec
