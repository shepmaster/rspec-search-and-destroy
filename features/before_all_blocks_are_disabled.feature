Feature: `before(:all)` blocks are disabled when all of the examples are also disabled

Scenario: Run it
  Given a file named "spec/spec_helper.rb" with:
    """ruby
    require 'rspec-sad'

    RSpec.configure do |config|
      RSpecSearchAndDestroy.configure(config)
    end
    """
  And a file named "spec/before_all_spec.rb" with:
    """ruby
    require 'spec_helper'

    describe 'Tests that have before :all' do
      context do
        before(:all) { puts 'example 1 - before :all' }
        it 'leaves bad global state' do
          $global_state = true
          expect($global_state).to be true
        end
      end

      context do
        before(:all) { puts 'example 2 - before :all' }
        it do
          expect(true).to be true
        end
      end

      context do
        before(:all) { puts 'example 3 - before :all' }
        it 'relies on global state' do
          expect($global_state).to be false
        end
      end
    end
    """
  When I run `rspec-sad`
  Then the output should contain "example 2 - before :all" 1 time
