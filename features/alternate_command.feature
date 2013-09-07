Feature: A command other than `rspec` can be run

Scenario: Run it
  Given a configured spec/spec_helper.rb
  And a file named "intermediate_runner.sh" with:
    """
    echo 'Running the intermediate script'
    rspec
    """
  And a file named "spec/example_spec.rb" with:
    """ruby
    require 'spec_helper'

    describe "Tests that fail when run in a specific order" do
      it "leaves bad global state" do
        $global_state = true
        expect($global_state).to be true
      end

      it "just takes up space" do
        expect(true).to be true
      end

      it "fails when run last" do
        expect($global_state).to be false
      end
    end
    """
  When I run `rspec-sad --rspec-command='bash ./intermediate_runner.sh'`
  Then the output should contain "Running the intermediate script"
  And the output should contain "Culprit found"
