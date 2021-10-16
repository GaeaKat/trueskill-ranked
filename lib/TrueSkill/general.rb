# frozen_string_literal: true

MU = 25.0
SIGMA = MU / 3
BETA = SIGMA / 2
TAU = SIGMA / 100
DRAW_PROBABILITY = 0.10
DELTA = 0.001

$vFunc = proc do |diff, draw_margin|
  x = diff - draw_margin
  pdf(x) / cdf(x)
end

$wFunc = proc do |diff, draw_margin|
  x = diff - draw_margin
  v = $vFunc.call(diff, draw_margin)
  v * (v + x)
end

$v_drawFunc = proc do |diff, draw_margin|
  abs_diff = diff.abs
  a = draw_margin - abs_diff
  b = -draw_margin - abs_diff
  denom = cdf(a) - cdf(b)
  numer = pdf(b) - pdf(a)
  numer / denom * (diff.negative? ? -1 : 1)
end
$w_drawFunc = proc do |diff, draw_margin|
  abs_diff = diff.abs
  a = draw_margin - abs_diff
  b = -draw_margin - abs_diff
  denom = cdf(a) - cdf(b)
  v = $v_drawFunc.call(abs_diff, draw_margin)
  (v ** 2) + (a * pdf(a) - b * pdf(b)) / denom
end

def calc_draw_probability(draw_margin, beta, size)
  2 * cdf(draw_margin * (Math.sqrt(size) * beta)) - 1
end

def calc_draw_margin(draw_probability, beta, size)
  ppf((draw_probability + 1) / 2.0) * Math.sqrt(size) * beta
end

def _team_sizes(rating_groups)
  team_sizes = [0]
  rating_groups.each do |group|
    team_sizes << group.length + team_sizes.last
  end
  team_sizes.delete_at(0)
  team_sizes
end

$global = []

def g
  setup if $global.length.zero?
  $global[0]
end

def setup(mu = MU, sigma = SIGMA, beta = BETA, tau = TAU, draw_probability = DRAW_PROBABILITY, env = nil)
  $global.pop
  $global << if env.nil?
               TrueSkillObject.new(mu, sigma, beta, tau, draw_probability)
             else
               env
             end
  g
end
