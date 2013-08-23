require "rspec-search-and-destroy/version"
require "rspec-search-and-destroy/bisector"
require "rspec-search-and-destroy/binary_chop_example_selector"

require 'rspec'
require 'rspec/core/formatters/base_formatter'

module RSpecSearchAndDestroy
  RESULT_FILE = "/tmp/example-results"
  EXAMPLE_FILE = '/tmp/examples-to-run'

  def self.configure(config)
    config.add_formatter(OrderFormatter)

    if File.exist? EXAMPLE_FILE
      config.order_examples(&RSpecSearchAndDestroy::ReorderAndFilter.block)
    end
  end

  class OrderFormatter < RSpec::Core::Formatters::BaseFormatter
    def stop
      File.open(RESULT_FILE, 'wb') do |f|
        Marshal.dump(results, f)
      end

      super
    end

    private

    def results
      examples.map do |e|
        {
          location: e.location,
          failed: !!e.exception
        }
      end
    end
  end

  class LocationSource
    def example_locations_to_run
      File.open(EXAMPLE_FILE, 'rb') do |f|
        Marshal.load(f)
      end
    end
  end

  class ReorderAndFilter
    def self.block(source = LocationSource.new)
      lambda do |examples|
        locations = source.example_locations_to_run

        enabled_examples = examples.select do |e|
          locations.include? e.location
        end

        enabled_examples.sort_by do |e|
          locations.index(e.location)
        end
      end
    end
  end

  class RSpecResults
    attr_reader :results

    def initialize(results)
      @results = results
    end

    def causal_examples
      results.slice(0, failure_index)
    end

    def failed_example
      results[failure_index]
    end

    def failed?
      results.find {|result| result[:failed] }
    end

    private

    def failure_index
      @failure_index ||= results.find_index { |r| r[:failed] }
    end
  end

  class RSpecDriver
    def self.load_run_results
      File.open(RESULT_FILE, 'rb') do |f|
        RSpecResults.new(Marshal.load(f))
      end
    end

    def self.run_examples(examples)
      locations = examples.map {|x| x[:location]}

      File.open(EXAMPLE_FILE, 'wb') do |f|
        Marshal.dump(locations, f)
      end

      puts "run it now... (enter when done)"
      gets
    end
  end
end
