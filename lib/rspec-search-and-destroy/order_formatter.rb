require 'rspec/core/formatters/base_formatter'

module RSpecSearchAndDestroy
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
end
