require 'spec_helper'
require 'rspec-search-and-destroy/io_output.rb'

module RSpecSearchAndDestroy
  describe IOOutput do
    let(:output) { IOOutput.new(io) }
    let(:io) { StringIO.new }
    subject(:string) { io.string }

    context "when reporting the culprit" do
      let(:causal_example) { {location: "cause location"} }
      let(:failed_example) { {location: "fail location"} }

      before do
        output.found(causal_example, failed_example)
      end

      it "includes the example that causes the problem" do
        expect(string).to match /Run\s+cause location/
      end

      it "includes the example that fails" do
        expect(string).to match /Before\s+fail location/
      end
    end
  end
end
