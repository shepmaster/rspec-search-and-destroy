require 'rspec-sad'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.color = true
  config.formatter = 'progress'

  # Order these tests to guarantee a failure
  config.order = 'default'

  RSpecSearchAndDestroy.configure(config)
end
