require "rspec-search-and-destroy/version"
require "rspec-search-and-destroy/bisector"
require "rspec-search-and-destroy/binary_chop_example_selector"

require 'rspec'
require 'rspec/core/formatters/base_formatter'

module RSpecSearchAndDestroy
  def self.configure(config)
    config.add_formatter(OrderFormatter)

    source = LocationSource.new
    if source.enabled?
      ordering = ReorderAndFilter.new(source)
      config.order_examples(&ordering.block)
    end
  end

  class OrderFormatter < RSpec::Core::Formatters::BaseFormatter
    def stop
      File.open(filename, 'wb') do |f|
        Marshal.dump(results, f)
      end

      super
    end

    private

    def filename
      ENV['RSPEC_SAD_RESULTS'] or raise "No result filename provided"
    end

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
    def enabled?
      filename && File.exist?(filename)
    end

    def example_locations_to_run
      raise "LocationSource is not currently enabled" unless enabled?

      File.open(filename, 'rb') do |f|
        Marshal.load(f)
      end
    end

    private

    def filename
      ENV['RSPEC_SAD_EXAMPLES']
    end
  end

  class ReorderAndFilter
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def block
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
    RESULT_FILE = '/tmp/example-results'
    EXAMPLE_FILE = '/tmp/examples-to-run'

    def load_run_results
      File.open(RESULT_FILE, 'rb') do |f|
        RSpecResults.new(Marshal.load(f))
      end
    end

    def initial_run
      cleanup
      run_rspec
    end

    def run_examples(examples)
      locations = examples.map {|x| x[:location]}

      File.open(EXAMPLE_FILE, 'wb') do |f|
        Marshal.dump(locations, f)
      end

      run_rspec
    end

    def cleanup
      [EXAMPLE_FILE, RESULT_FILE].each do |fname|
        File.delete(fname) if File.exist? fname
      end
    end

    private

    def run_rspec
      puts "run this:"
      puts "RSPEC_SAD_EXAMPLES=#{EXAMPLE_FILE} RSPEC_SAD_RESULTS=#{RESULT_FILE} rspec"
      puts "(enter when done)"
      gets
    end
  end
end
