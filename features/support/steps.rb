Given(/^a configured spec\/spec_helper\.rb$/) do
  config = <<CONFIG
require 'rspec-sad'

RSpec.configure do |config|
  RSpecSearchAndDestroy.configure(config)
end
CONFIG

  write_file("spec/spec_helper.rb", config )
end

Then(/^the output should contain "(.*?)" (\d+) times?$/) do |expected_output, expected_count|
  actual_count = all_output.scan(expected_output).length
  expect(actual_count).to eql expected_count.to_i
end
