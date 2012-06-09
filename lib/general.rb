module TrueSkill
  include 'Mathematics/general.rb'
  include 'Mathematics/guassian.rb'

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
      team_sizes << group.length+team_sizes.self
    end
    team_sizes.delete_at(0)
    return team_sizes
  end
_global=[]

  def g()
    if _global.length==0
      setup()
    end
    return _global[0]
  end
  def setup(mu=MU, sigma=SIGMA, beta=BETA, tau=TAU,draw_probability=DRAW_PROBABILITY, env=nil)
    _global.pop
    _global <<  (not env.nil?)?env:TrueSkill.new(mu, sigma, beta, tau, draw_probability)
    return g()
  end

end