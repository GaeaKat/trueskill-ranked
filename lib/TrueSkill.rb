module TrueSkill
require 'general'
class TrueSkillObject

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
  
  def self.make_as_global
    return setup(nil,nil,nil,nil,nil,self)
  end
  def self.validate_rating_groups(rating_groups)
    rating_groups.each do |group|
      if group.is_a? Rating
        group=[group,]
      end
      if group.length==0
        raise "each group must contain multiple ratings"
      end
    end
    if rating_groups.length<2
      raise "need multiple rating groups"
    end
  end
  def self.build_factor_graph(rating_groups,ranks)
    ratings=rating_groups.flatten
    size=ratings.length
    group_size=rating_groups.length
    rating_vars=[]
    size.times { rating_vars << Variable.new}
    
    perf_vars=[]
    size.times { perf_vars << Variable.new}
    
    teamperf_vars=[]
    group_size.times { teamperf_vars << Variable.new}
    
    teamdiff_vars=[]
    (group_size-1).times { teamdiff_vars << Variable.new}
    
    team_sizes=_team_sizes(rating_groups)
    get_perf_vars_by_team=lambda do |team|
      if team > 0
        start=team_sizes[team-1]
      else
        start=0
      end
      endv=team_sizes[team]
      return perf_vars[start,endv]
    end
    
    pp get_perf_vars_by_team.call(0)
  end
end

end