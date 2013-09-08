Feature: Running RSpec when SAD is configured

Scenario: Run it
  Given a configured spec/spec_helper.rb
  And a file named "spec/empty_spec.rb" with:
    """ruby
    require 'spec_helper'
    """
  When I run `rspec`
  Then the exit status should be 0
