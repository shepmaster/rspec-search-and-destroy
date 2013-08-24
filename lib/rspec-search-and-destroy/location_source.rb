module RSpecSearchAndDestroy
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
end
