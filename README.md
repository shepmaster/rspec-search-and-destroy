RSpec Search-and-Destroy (SAD) runs your RSpec suites to automatically
find the root causes of test ordering bugs.

# Background

Ideally, tests are independent of each other, but sometimes global
state can leak out of one test and cause another test to fail. When
you have many tests, these types of failures can be insidious to
debug.

# Usage

First, add the appropriate hooks in your `spec_helper.rb`:

```ruby
require 'rspec-sad'

RSpec.configure do |config|
  RSpecSearchAndDestroy.configure(config)
end
```

Then run the driver program:

```
# Search and destroy mode
rspec-sad

# If you have a particular ordering that creates issues
SPEC_OPTIONS="--seed 12345" rspec-sad

# If you have a complicated script
rspec-sad --rspec-command "/path/to/script"
```

# Search and destroy mode

In the search phase, SAD will run your test suite until a test failure
occurs, then switch to the destroy phase. In the destroy phase, the
contributing tests are narrowed down until a single test is found that
causes the failure.

# Caveats

RSpec SAD requires that your test suite not have any flaky tests. Any
intermittently failing tests will cause false positives or false
negatives. In this case, the results will not provide any useful
information.

# How it works

During the search phase, your test suite will be run once to get the
set of tests that could contribute to the test failure. The order of
tests will be saved and passed off to the destroy phase.

During each step of the destroy phase, half of the remaining tests
will be disabled. If the test continues to fail, these disabled tests
can be ignored. If the test stops failing, then the currently enabled
tests can be enabled.

## Implementation notes

The driver process runs RSpec as a subprocess. The two processes
communicate using environment variables and files. The driver program
specifies a set of tests to run, and RSpec reports the results back to
the driver.

The test ordering and filtering is done via a custom
`config.order_examples` block, and the results are saved using a
custom formatter.
