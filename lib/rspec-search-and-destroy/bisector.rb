module RSpecSearchAndDestroy
  class Bisector
    attr_reader :output, :selector, :executor

    def initialize(output, selector, executor)
      @output = output
      @selector = selector
      @executor = executor
    end

    def bisect(causal_examples, failed_example)
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
      executor.run_examples(to_run)

      results = executor.load_run_results

      if results.failed?
        bisect(enabled, failed_example)
      else
        bisect(disabled, failed_example)
      end
    end
  end
end
