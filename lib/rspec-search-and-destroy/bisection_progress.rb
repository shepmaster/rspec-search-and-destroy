class BisectionProgress
  attr_reader :iteration, :enabled_examples, :total_examples, :start_time

  def initialize(attributes = {})
    @iteration = attributes.fetch(:iteration) { 1 }
    @enabled_examples = attributes.fetch(:enabled_examples)
    @total_examples = attributes.fetch(:total_examples)
    @time_provider = attributes.fetch(:time_provider) { Time }
    @start_time = attributes.fetch(:start_time) { @time_provider.now }
  end

  def next_iteration(enabled_examples)
    self.class.new(iteration: iteration + 1,
                   enabled_examples: enabled_examples,
                   total_examples: total_examples,
                   time_provider: @time_provider,
                   start_time: start_time)
  end

  def run_time
    @time_provider.now - @start_time
  end

  def ==(other)
    values.map do |v|
      self.send(v) == other.send(v)
    end.all?
  end

  def hash
    values.map do |v|
      self.send(v).hash
    end.reduce(:^)
  end

  private

  def values
    [:iteration, :enabled_examples, :total_examples]
  end
end
