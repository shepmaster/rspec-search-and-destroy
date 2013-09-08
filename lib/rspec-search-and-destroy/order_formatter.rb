require 'rspec/core/formatters/base_formatter'

module RSpecSearchAndDestroy
  class OrderFormatter < RSpec::Core::Formatters::BaseFormatter
    def stop
      if enabled?
        File.open(filename, 'wb') do |f|
          Marshal.dump(results, f)
        end
      end

      super
    end

    private

    def enabled?
      filename
    end

    def filename
      ENV['RSPEC_SAD_RESULTS']
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
