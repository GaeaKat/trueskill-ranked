module TrueSkill
include 'general.rb'
class TrueSkill

  attr_accessor :mu,:sigma,:beta,:tau,:draw_probability

  @mu=nil
  @sigma=nil
  @beta=nil
  @tau=nil
  @draw_probability=nil
  
  def initialize(mu=MU, sigma=SIGMA, beta=BETA, tau=TAU,draw_probability=DRAW_PROBABILITY)
    @mu=mu
    @sigma=sigma
    @beta=beta
    @tau=tau
    @draw_probability=draw_probability
  end
  
  
  def Rating(mu=nil,sigma=nil)
    if mu.nil?
      mu=@mu
    end
    if sigma.nil?
      sigma=@sigma
    end
    return Rating.new mu,sigma
  end
  
  def make_as_global
    return setup(nil,nil,nil,nil,nil,self)
  end
  def validate_rating_groups(rating_groups)
    rating_groups.each do |group|
      if group.is_a? Rating
        group=[group,]
      end
    end
  end
end

end