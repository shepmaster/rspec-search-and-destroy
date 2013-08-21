RSpec Search-and-Destroy (SAD) runs your RSpec suites to automatically
find the root causes of test ordering bugs.

# Background

TODO: Describe the problem, and provide examples

# Usage

```
# Search and destroy mode
rspec-sad

# Destroy mode
rspec-sad --seed 12345 --failing-test 'a test that fails but should not'

# Multi-target destroy mode
rspec-sad --multi-target
rspec-sad --multi-target \
  --seed 12345 --failing-test 'a test that fails but should not'
```

# Search and destroy mode

In the search phase, SAD will run your test suite until a test failure
occurs, then switch to the destroy phase. In the destroy phase, the
contributing tests are narrowed down until a single test is found that
causes the failure.

# Destroy mode

If you already know that you have a failing test, you can give the
process a jump by providing that information to start with.

# Multi-target destroy mode

Sometimes multiple tests can contribute to a failure. If no single
test can be found that causes the problem, then it may be worth trying
multi-target destroy mode. This mode can be much slower than the
regular mode, and may not produce the smallest set of tests that
contribute.

# Caveats

RSpec SAD requires that your test suite not have any flaky tests. Any
intermittently failing tests will

# How it works

During the search phase, your test suite will be run with various
orderings, as controlled by the RSpec `--seed` option. Once a test
fails, the order of tests will be saved and passed off to the destroy
phase.

During each step of the destroy phase, half of the remaining tests
will be disabled. If the test continues to fail, these disabled tests
can be ignored. If the test stops failing, then the currently enabled
tests can be enabled.

During the multi-target destroy phase, a random set of the preceding
tests will be disabled. If the test continues to fail, the disabled
tests can be ignored. Unfortunately, if the test stops failing, then
nothing can be determined, and a different set of tests must be
disabled.

## Implementation notes

The driver program will be one process and start RSpec as a
subprocess. It will control the random seed, and fail fast.  The
failed tests will be passed back to the driver program via a custom
formatter.

The set of tests to run will be passed via environment variables, and
the ordering will be enforced using the `example_ordering_block`
configuration option.
