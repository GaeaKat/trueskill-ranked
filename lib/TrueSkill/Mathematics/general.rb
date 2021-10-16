# frozen_string_literal: true

def ierfcc(p)
  return -100 if p >= 2.0
  return 100 if p <= 0.0

  pp = p < 1.0 ? p : 2 - p
  t = Math.sqrt(-2 * Math.log(pp / 2.0)) # Initial guess
  x = -0.70711 * ((2.30753 + t * 0.27061) / (1.0 + t * (0.99229 + t * 0.04481)) - t)
  [0, 1].each do |_j|
    err = Math.erfc(x) - pp
    x += err / (1.12837916709551257 * Math.exp(-(x * x)) - x * err)
  end
  p < 1.0 ? x : -x
end

def cdf(x, mu = 0, sigma = 1)
  0.5 * Math.erfc(-(x - mu) / (sigma * Math.sqrt(2)))
end

def pdf(x, mu = 0, sigma = 1)
  (1 / Math.sqrt(2 * Math::PI) * sigma.abs) * Math.exp(-(((x - mu) / sigma.abs)**2 / 2))
end

def ppf(x, mu = 0, sigma = 1)
  mu - sigma * Math.sqrt(2) * ierfcc(2 * x)
end
