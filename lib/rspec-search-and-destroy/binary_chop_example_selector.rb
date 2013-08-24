module RSpecSearchAndDestroy
  class BinaryChopExampleSelector
    def enable_set(examples)
      half_size = examples.size / 2

      enabled = examples.slice(0, half_size)
      disabled = examples.slice(half_size..-1)

      [enabled, disabled]
    end
  end
end
