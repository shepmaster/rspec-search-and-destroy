require_relative 'bisection_progress'

module RSpecSearchAndDestroy
  class Bisector
    attr_reader :output, :selector, :executor

    def initialize(output, selector, executor)
      @output = output
      @selector = selector
      @executor = executor
    end

    def bisect(causal_examples, failed_example, progress = nil)
      case causal_examples.size
      when 1
        output.found(causal_examples.first, failed_example)
        return
      when 0
        output.unable_to_bisect
        return
      end

      enabled, disabled = selector.enable_set(causal_examples)
      to_run = enabled + [failed_example]

      progress =
        if progress
          progress.next_iteration(enabled.size)
        else
          BisectionProgress.new(total_examples: causal_examples.size,
                                enabled_examples: enabled.size)
        end
      output.progress(progress)

      executor.run_examples(to_run)
      results = executor.load_run_results

      next_set = results.failed? ? enabled : disabled
      bisect(next_set, failed_example, progress)
    end
  end
end
