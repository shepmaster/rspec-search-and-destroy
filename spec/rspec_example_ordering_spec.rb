require 'spec_helper'
require 'rspec-sad'

describe RSpecSearchAndDestroy::ReorderAndFilter do
  subject(:ordering_block) do
    RSpecSearchAndDestroy::ReorderAndFilter.new(location_source).block
  end

  let(:location_source) { double("location source") }

  context "when filtering examples" do
    let(:examples) do
      [double('example 1', location: 'location 1'),
       double('example 2', location: 'location 2')]
    end

    before do
      location_source.stub(:example_locations_to_run)
        .and_return ["location 1"]
    end

    it "leaves examples that are enabled" do
      sorted_examples = ordering_block.call(examples)

      expect(sorted_examples).to include examples.first
    end

    it "removes examples that are not enabled" do
      sorted_examples = ordering_block.call(examples)

      expect(sorted_examples).to_not include examples.last
    end
  end

  context "when reordering examples" do
    let(:examples) do
      [double('example 1', location: 'location 1'),
       double('example 2', location: 'location 2')]
    end

    before do
      location_source.stub(:example_locations_to_run)
        .and_return ["location 2", "location 1"]
    end

    it "reorders examples to match" do
      sorted_examples = ordering_block.call(examples)

      expect(sorted_examples).to eql [examples.last, examples.first]
    end
  end
end
