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

    context "when reporting progress" do
      let(:progress) do
        BisectionProgress.new(iteration: 5,
                              enabled_examples: 54,
                              total_examples: 999)
      end

      before do
        output.progress(progress)
      end

      it "includes the current iteration" do
        expect(string).to match /Iteration 5/
      end

      it "includes the number of enabled examples" do
        expect(string).to match /54.*examples/
      end

      it "includes the total number of examples" do
        expect(string).to match /999.*examples/
      end

      it "includes the running time" do
        expect(string).to match /Running for \d{2}:\d{2}:\d{2}/
      end
    end
  end
end
