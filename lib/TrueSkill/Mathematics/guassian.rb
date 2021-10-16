# frozen_string_literal: true

class Gaussian
  attr_accessor :pi, :tau, :mu, :sigma

  @pi = nil
  @tau = nil

  def initialize(mu = nil, sigma = nil, pi = 0, tau = 0)
    unless mu.nil?
      raise 'a variance(sigma^2) should be greater than 0' if sigma.nil? || (sigma == 0.0)

      pi = sigma**-2
      tau = pi * mu
    end
    @pi = pi
    @tau = tau
  end

  def mu
    @tau / @pi
  end

  def sigma
    return 1.0 / 0 if @pi.nil? || @pi.zero?

    Math.sqrt(1 / @pi)
  end

  def *(other)
    pi = @pi + other.pi
    tau = @tau + other.tau
    Gaussian.new(nil, nil, pi, tau)
  end

  def /(other)
    pi = @pi - other.pi
    tau = @tau - other.tau
    Gaussian.new(nil, nil, pi, tau)
  end
end
