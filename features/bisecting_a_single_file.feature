Feature: Bisecting a single file

Scenario: Run it
  Given a configured spec/spec_helper.rb
  And a file named "spec/single_file_spec.rb" with:
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
  When I run `rspec-sad`
  Then the output should contain "Culprit found"
  And the output should contain "Run    ./spec/single_file_spec.rb:4"
  And the output should contain "Before ./spec/single_file_spec.rb:13"
