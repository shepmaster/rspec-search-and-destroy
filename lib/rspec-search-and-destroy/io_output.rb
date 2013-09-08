class IOOutput
  attr_reader :io

  SEPARATOR = "-" * 20

  def initialize(io = STDOUT)
    @io = io
  end

  def found(causal_example, failed_example)
    io.puts <<FOUND
#{SEPARATOR}
Culprit found
Run    #{causal_example[:location]}
Before #{failed_example[:location]}
FOUND
  end

  def progress(state)
    run_time = Duration.new(state.run_time)

    io.puts <<PROGRESS
#{SEPARATOR}
Iteration #{state.iteration}
#{state.enabled_examples} / #{state.total_examples} examples enabled
Running for #{run_time}
PROGRESS
  end

  private

  class Duration
    attr_reader :hours, :minutes, :seconds

    def initialize(duration_as_seconds)
      total_seconds = duration_as_seconds.to_f.ceil.to_i

      @seconds = total_seconds % 60
      @minutes = (total_seconds / 60) % 60
      @hours = total_seconds / (60 * 60)
    end

    def to_s
      "%02d:%02d:%02d" % [hours, minutes, seconds]
    end
  end
end
