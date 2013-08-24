require 'rspec-sad'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.color = true
  config.formatter = 'documentation'

  # For this example, run in an order that is guaranteed to be bad
  config.order = 'default'

  RSpecSearchAndDestroy.configure(config)
end
