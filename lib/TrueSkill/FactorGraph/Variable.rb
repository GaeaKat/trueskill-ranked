# frozen_string_literal: true

class Variable < Gaussian
  @delta = nil

  def initialize
    super()
    @messages = {}
  end

  def set(val)
    @delta = delta(val)
    @pi = val.pi
    @tau = val.tau
  end

  def delta(other)
    [(@tau - other.tau).abs, Math.sqrt((@pi - other.pi).abs)].max
  end

  def update_message(factor, pi = 0, tau = 0, message = nil)
    message = Gaussian.new(nil, nil, pi, tau) if message.nil?
    old_message = self[factor]
    self[factor] = message
    set(self / old_message * message)
  end

  def update_value(factor, pi = 0, tau = 0, value = nil)
    value = Gaussian.new(nil, nil, pi, tau) if value.nil?
    old_message = self[factor]
    self[factor] = value * old_message / self
    set(value)
  end

  def [](y)
    @messages[y]
  end

  def []=(y, value)
    @messages[y] = value
  end

  def to_s
    "<Variable #{object_id} mu=#{mu} sigma= #{sigma}>"
  end
end
