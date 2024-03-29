# frozen_string_literal: true

class LikelihoodFactor < Factor
  @mean = nil
  @value = nil
  @variance = nil

  def initialize(mean_var, value_var, variance)
    super([mean_var, value_var])
    @mean = mean_var
    @value = value_var
    @variance = variance
  end

  def down
    val = @mean
    msg = val / @mean[self]
    pi = 1.0 / @variance
    a = pi / (pi + val.pi)
    @value.update_message(self, a * msg.pi, a * msg.tau)
  end

  def up
    val = @value
    msg = val / @value[self]
    a = 1.0 / (1.0 + @variance * msg.pi)
    @mean.update_message(self, a * msg.pi, a * msg.tau)
  end

  def to_s
    "<LiklihoodFactor #{object_id}>"
  end
end
