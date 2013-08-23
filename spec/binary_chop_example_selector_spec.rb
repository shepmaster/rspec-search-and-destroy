require 'spec_helper'
require 'rspec-search-and-destroy/binary_chop_example_selector'

describe RSpecSearchAndDestroy::BinaryChopExampleSelector do
  subject(:selector) { RSpecSearchAndDestroy::BinaryChopExampleSelector.new }

  context "when there is an even number of examples" do
    let(:examples) { 4.times.map {|i| double("example #{i}") } }

    it "includes all the examples" do
      enabled, disabled = selector.enable_set(examples)

      expect(enabled + disabled).to eql(examples)
    end

    it "enables exactly half of the examples" do
      enabled, disabled = selector.enable_set(examples)

      expect(enabled.size).to eql(examples.size / 2)
    end

    it "disables exactly half of the examples" do
      enabled, disabled = selector.enable_set(examples)

      expect(disabled.size).to eql(examples.size / 2)
    end
  end

  context "when there is an odd number of examples" do
    let(:examples) { 3.times.map {|i| double("example #{i}") } }

    it "includes all the examples" do
      enabled, disabled = selector.enable_set(examples)

      expect(enabled + disabled).to eql(examples)
    end

    it "enables about half of the examples" do
      enabled, disabled = selector.enable_set(examples)

      expect(enabled.size).to be_within(1).of(examples.size / 2)
    end

    it "disables about half of the examples" do
      enabled, disabled = selector.enable_set(examples)

      expect(disabled.size).to be_within(1).of(examples.size / 2)
    end
  end
end
