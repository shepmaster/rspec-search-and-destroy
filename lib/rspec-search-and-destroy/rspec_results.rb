module RSpecSearchAndDestroy
  class RSpecResults
    attr_reader :results

    def initialize(results)
      @results = results
    end

    def causal_examples
      results.slice(0, failure_index)
    end

    def failed_example
      results[failure_index]
    end

    def failed?
      results.find {|result| result[:failed] }
    end

    private

    def failure_index
      @failure_index ||= results.find_index { |r| r[:failed] }
    end
  end
end
