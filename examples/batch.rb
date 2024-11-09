#!/usr/bin/env ruby

require 'async'
require 'async/barrier'
require 'async/semaphore'
require 'csv'
require 'opencage/geocoder'

def main
  BatchGeocoder.new(
    api_key: '',
    infile: 'addresses.csv',
    outfile: 'geocoded.csv',
    max_items: 20, # Set to nil for unlimited
    num_workers: 3 # For 10 requests per second try 2-5
  ).call
end

class BatchGeocoder
  attr_reader :api_key, :infile, :outfile, :max_items, :num_workers

  def initialize(api_key:, infile:, outfile:, max_items:, num_workers:)
    @api_key = api_key
    @infile = infile
    @outfile = outfile
    @max_items = max_items
    @num_workers = num_workers
  end

  def call
    # NOTE: Refer to `async` gem best practices documentation [1] for
    # more information on async barriers and semaphores.
    #
    # [1] https://socketry.github.io/async/guides/best-practices/index.html

    # Use a barrier to ensure all tasks complete.
    barrier = Async::Barrier.new
    csv_writer = CSV.open(File.expand_path(outfile, __dir__), 'w', headers: %w[id lat lng address])

    Sync do
      # Use a semaphore to limit maximum concurrency.
      semaphore = Async::Semaphore.new(num_workers, parent: barrier)
      tasks = lines.map { |line| geocode_line(line, csv_writer, semaphore) }

      tasks.map(&:wait)
    ensure
      barrier.stop
      csv_writer.close
    end
  end

  private

  def geocode_line(line, csv_writer, semaphore)
    semaphore.async do
      results = geocoder.geocode(line['address'])
      csv_writer << [line['id'], results.first.coordinates, line['address']].flatten
    end
  end

  def geocoder
    @geocoder ||= OpenCage::Geocoder.new(api_key: api_key)
  end

  def lines
    csv_reader = CSV.read(File.expand_path(infile, __dir__), headers: true)
    max_items.nil? ? csv_reader : csv_reader.first(max_items)
  end
end

main
