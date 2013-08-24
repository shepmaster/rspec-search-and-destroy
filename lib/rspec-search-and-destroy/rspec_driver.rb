require_relative 'rspec_results'

module RSpecSearchAndDestroy
  class RSpecDriver
    RESULT_FILE = '/tmp/example-results'
    EXAMPLE_FILE = '/tmp/examples-to-run'

    def load_run_results
      unless File.exist? RESULT_FILE
        raise <<ERR
The RSpec result file was not created. Please ensure that SAD is
added to your RSpec configuration.
ERR
      end

      File.open(RESULT_FILE, 'rb') do |f|
        RSpecResults.new(Marshal.load(f))
      end
    end

    def initial_run
      cleanup
      run_rspec
    end

    def run_examples(examples)
      locations = examples.map {|x| x[:location]}

      File.open(EXAMPLE_FILE, 'wb') do |f|
        Marshal.dump(locations, f)
      end

      run_rspec
    end

    def cleanup
      [EXAMPLE_FILE, RESULT_FILE].each do |fname|
        File.delete(fname) if File.exist? fname
      end
    end

    private

    def run_rspec
      env = {
        "RSPEC_SAD_EXAMPLES" => EXAMPLE_FILE,
        "RSPEC_SAD_RESULTS" => RESULT_FILE
      }
      cmd = "rspec"

      success = system(env, cmd)

      raise "unable to run command: #{cmd}" if success.nil?
    end
  end
end
