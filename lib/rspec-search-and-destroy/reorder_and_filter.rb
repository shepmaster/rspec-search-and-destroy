module RSpecSearchAndDestroy
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
end
