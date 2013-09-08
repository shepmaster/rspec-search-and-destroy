class IOOutput
  attr_reader :io

  def initialize(io = STDOUT)
    @io = io
  end

  def found(causal_example, failed_example)
    io.puts <<FOUND
Culprit found
Run    #{causal_example[:location]}
Before #{failed_example[:location]}
FOUND
  end
end
