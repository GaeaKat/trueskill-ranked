# frozen_string_literal: true

class Rating < Gaussian
  attr_accessor :exposure

  def initialize(mu = nil, sigma = nil)
    mu, sigma = mu if mu.is_a?(Array)
    mu = g.mu if mu.nil?
    sigma = g.sigma if sigma.nil?
    super(mu, sigma)
  end

  def exposure
    mu - 3 * sigma
  end

  def to_s
    "[mu=#{mu},sigma=#{sigma}]"
  end
end
