require 'spec_helper'
require 'rspec-search-and-destroy/bisector.rb'

describe RSpecSearchAndDestroy::Bisector do
  subject(:bisector) do
    RSpecSearchAndDestroy::Bisector.new(output, selector, executor)
  end

  let(:output)   { double("output") }
  let(:selector) { double("selector") }
  let(:executor) { double("executor") }

  let(:failing_example) { double("failing example") }

  context "when there is only one potential test left" do
    let(:potential_causes) { [double("bad example")] }

    it "reports that it has finished" do
      expect(output).to receive(:found)
        .with(potential_causes.first, failing_example)

      bisector.bisect(potential_causes, failing_example)
    end
  end

  context "when there are no potential tests left" do
    let(:potential_causes) { [] }

    it "reports the error condition" do
      expect(output).to receive(:unable_to_bisect)

      bisector.bisect(potential_causes, failing_example)
    end
  end

  context "when executing examples" do
    let(:potential_causes) { 2.times.map {|i| double("potential example #{i}")} }
    let(:enabled_examples) { [potential_causes.first] }
    let(:disabled_examples) { [potential_causes.last] }

    before do
      selector.stub(:enable_set)
        .and_return([enabled_examples, disabled_examples])

      # These stubs do not provide useful feedback for these tests,
      # they are just needed to prevent failure
      results = double("results", :failed? => true)
      executor.stub(:load_run_results).and_return(results)
      output.stub(:found)
    end

    it "executes enabled examples" do
      expect(executor).to receive(:run_examples) do |enabled_examples|
        expect(enabled_examples).to include(*enabled_examples)
      end

      bisector.bisect(potential_causes, failing_example)
    end

    it "does not execute disabled examples" do
      expect(executor).to receive(:run_examples) do |enabled_examples|
        expect(enabled_examples).to_not include(*disabled_examples)
      end

      bisector.bisect(potential_causes, failing_example)
    end

    it "executes the failing test last" do
      expect(executor).to receive(:run_examples) do |enabled_examples|
        expect(enabled_examples.last).to eql(failing_example)
      end

      bisector.bisect(potential_causes, failing_example)
    end

    context "when the executed tests fail" do
      before do
        executor.stub(:run_examples)
        results = double("results", :failed? => true)
        executor.stub(:load_run_results).and_return(results)
      end

      it "continues exploring the enabled tests" do
        expect(output).to receive(:found)
          .with(enabled_examples.first, failing_example)

        bisector.bisect(potential_causes, failing_example)
      end
    end

    context "when the executed tests do not fail" do
      before do
        executor.stub(:run_examples)
        results = double("results", :failed? => false)
        executor.stub(:load_run_results).and_return(results)
      end

      it "continues exploring the disabled tests" do
        expect(output).to receive(:found)
          .with(disabled_examples.first, failing_example)

        bisector.bisect(potential_causes, failing_example)
      end
    end
  end
end
