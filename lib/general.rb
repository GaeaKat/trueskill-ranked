module TrueSkill
  require 'Mathematics/general.rb'
  require 'Mathematics/guassian.rb'
  require 'TrueSkill'
  require 'FactorGraph/Variable'
  MU=25.0
  SIGMA=MU/3
  BETA=SIGMA/2
  TAU=SIGMA/100
  DRAW_PROBABILITY=0.10
  DELTA=0.001


  def V(diff,draw_margin)
    x=diff-draw_margin
    return pdf(x)/cdf(x)
  end
  
  def W(diff,draw_margin)
    x=diff-draw_margin
    v=V(diff,draw_margin)
    return v*(v+x)
  end
  
  def V_draw(diff,draw_margin)
    abs_diff=diff.abs
    a=draw_margin-abs_diff
    b=-draw_margin-abs_diff
    denom=cdf(a)-cdf(b)
    numer=pdf(b)-pdf(a)
    return numer/denom*((diff<0)?-1:1)
  end
  def W_draw(diff,draw_margin)
    abs_diff=diff.abs
    a=draw_margin-abs_diff
    b=-draw_margin-abs_diff
    denom=cdf(a)-cdf(b)
    v=V_draw(abs_diff,draw_margin)
    return (v**2)+(a*pdf(a)-b*pdf(b))/denom
  end
  
  def calc_draw_probability(draw_margin,beta,size)
    return 2*cdf(draw_margin*(Math.sqrt(size)*beta))-1
  end
  
  def calc_draw_margin(draw_probability, beta, size)
    return ppf((draw_probability+1)/2.0)*Math.sqrt(size)*beta
  end
  
  def _team_sizes(rating_groups)
    team_sizes=[0]
    rating_groups.each do |group|
      team_sizes << group.length+team_sizes.last
    end
    team_sizes.delete_at(0)
    return team_sizes
  end
$global=[]

  def g()
    if $global.length==0
      setup()
    end
    return $global[0]
  end
  def setup(mu=MU, sigma=SIGMA, beta=BETA, tau=TAU,draw_probability=DRAW_PROBABILITY, env=nil)
    $global.pop
    if env.nil?
      $global << TrueSkillObject.new(mu, sigma, beta, tau, draw_probability)
    else
      $global << env
    end
    return g()
  end

end