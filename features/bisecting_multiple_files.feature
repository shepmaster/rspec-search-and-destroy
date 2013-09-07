Feature: Bisecting multiple files

Scenario: Run it
  Given a configured spec/spec_helper.rb
  And a file named "spec/file_1_spec.rb" with:
    """ruby
    require 'spec_helper'

    describe 'group 1' do
      it '1 - sets bad global state' do
        $global_state = true
        expect($global_state).to be_true
      end
    end
    """
  And a file named "spec/file_2_spec.rb" with:
    """ruby
    require 'spec_helper'

    describe 'group 2' do
      it '2 - just takes up space' do
        expect(true).to be_true
      end
    end
    """
  And a file named "spec/file_3_spec.rb" with:
    """ruby
    require 'spec_helper'

    describe 'group 3' do
      it '3 - fails because of global state' do
        expect($global_state).to be_false
      end
    end
    """
  When I run `rspec-sad`
  Then the output should contain "Culprit found"
  And the output should contain "Run    ./spec/file_1_spec.rb:4"
  And the output should contain "Before ./spec/file_3_spec.rb:4"
