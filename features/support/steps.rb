Then(/^the output should contain "(.*?)" (\d+) times?$/) do |expected_output, expected_count|
  actual_count = all_output.scan(expected_output).length
  expect(actual_count).to eql expected_count.to_i
end
