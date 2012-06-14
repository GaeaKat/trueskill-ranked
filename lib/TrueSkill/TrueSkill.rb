
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
  
  def make_as_global
    return setup(nil,nil,nil,nil,nil,self)
  end
  def validate_rating_groups(rating_groups)
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
    return rating_groups
  end
  def build_factor_graph(rating_groups,ranks)
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
    
    build_rating_layer=lambda do
      Enumerator.new do |yielder|
      
        rating_vars.zip(ratings).each do |rating_var,rating|
          yielder.yield(PriorFactor.new(rating_var,rating,@tau))
        end
      end
    end
    build_perf_layer=lambda do
      Enumerator.new do |yielder|
      
        rating_vars.zip(perf_vars).each do |rating_var,perf_var|
          yielder.yield(LikelihoodFactor.new(rating_var,perf_var,@beta**2))
        end
      end
    end
    build_teamperf_layer=lambda do
     Enumerator.new do |yielder|
       teamperf_vars.each_with_index do |teamperf_var,team|
          child_perf_vars = get_perf_vars_by_team.call(team)
          yielder.yield(SumFactor.new(teamperf_var,child_perf_vars,[1]*child_perf_vars.length))
       end
     end
   end
   build_teamdiff_layer=lambda do
    Enumerator.new do |yielder|
      teamdiff_vars.each_with_index do |teamdiff_var,team|
        yielder.yield(SumFactor.new(teamdiff_var,teamperf_vars[team,team=2],[+1,-1]))
      end
    end
   end
   build_trunc_layer=lambda do
    Enumerator.new do |yielder|
      teamdiff_vars.each_with_index do |teamdiff_var,x|
        size=0
        rating_groups[x,x+2].each do |group|
          size+=group.length
        end
        draw_margin=calc_draw_margin(@draw_probability,@beta,size)
        
        if ranks[x]==ranks[x+1]
          v_func,w_func=$v_drawFunc,$w_drawFunc
        else
          v_func,w_func=$vFunc,$wFunc
        end
        yielder.yield(TruncateFactor.new(teamdiff_var,v_func,w_func,draw_margin))
      end
    end
   end
   
   return Array(build_rating_layer.call),Array(build_perf_layer.call),Array(build_teamperf_layer.call),Array(build_teamdiff_layer.call),Array(build_trunc_layer.call)
  end
  
  def run_schedule(rating_layer, perf_layer, teamperf_layer,teamdiff_layer, trunc_layer, min_delta=DELTA)
    [rating_layer,perf_layer,teamperf_layer].flatten.each do |f|
      f.down
    end
    teamdiff_len=teamdiff_layer.length
    (10).times do |x|
      if teamdiff_len==1
        teamdiff_layer[0].down
        delta=trunc_layer[0].up
      else
        delta=0
        (teamdiff_len-1).times do |x2|
          teamdiff_layer[x2].down
          delta=[delta,trunc_layer[x2].up].max
          teamdiff_layer[x2].up(1)
        end
        (teamdiff_len-1).step(0,-1) do |x2|
          teamdiff_layer[x2].down
          delta=[delta,trunc_layer[x2].up].max
          teamdiff_layer[x2].up(0)
        end
      end
      if delta<=min_delta
        break
      end
    end
    teamdiff_layer.first.up(0)
    teamdiff_layer.last.up(1)
    teamperf_layer.each do |f|
      (f.vars.length-1).times do |x|
        f.up(x)
      end
    end
    perf_layer.each do |f|
      f.up
    end
  end
  def transform_ratings(rating_groups, ranks=nil, min_delta=DELTA)
    rating_groups=validate_rating_groups(rating_groups)
    #pp "Start groups"
    #pp rating_groups
    group_size=rating_groups.length
    if ranks.nil?
      ranks=Array(0..group_size-1)
    end
    sorting=ranks.zip(rating_groups).each_with_index.to_a.map {|x| x.reverse}.sort { |x,y| x[1][0] <=> y[1][0]}
    sorted_groups=[]
    sorting.each do |x,g|
      sorted_groups << g[1]
    end
    sorted_ranks=ranks.sort()
    unsorting_hint=[]
    sorting.each do |x,g|
      unsorting_hint << x
    end
    #pp "Sorted Groups"
    #pp sorted_groups
    #pp "Sorted Ranks"
    #pp sorted_ranks
    layers=build_factor_graph(sorted_groups,sorted_ranks)
    run_schedule(layers[0],layers[1],layers[2],layers[3],layers[4])
    rating_layer,team_sizes=layers[0],_team_sizes(sorted_groups)
    #pp "Team Sizes"
    #pp team_sizes
    #pp "Rating Layer"
    #pp rating_layer
    transformed_groups=[]
    ([0]+team_sizes.take(team_sizes.size - 1)).zip(team_sizes).each do |start,ending|
      group=[]
      rating_layer[start...ending].each do |f|
        group << Rating.new(f.var.mu,f.var.sigma)
      end
      transformed_groups << Array(group)
    end
    #pp "Transformed"
    #pp transformed_groups
    unsorting=unsorting_hint.zip(transformed_groups).sort { |x,y| x[0]<=>y[0]}
    output=[]
    unsorting.each do |x,g|
      output << g
    end
    return output
  end
  #def match_quality(rating_groups)
    #rating_groups=validate_rating_groups(rating_groups)
    #ratings=rating_groups.flatten
    #length=ratings.length
    #mean_rows=[]
    #ratings.each {|r| mean_rows << [r.mu] }
    #mean_matrix=Matrix[*mean_rows]
    #variance_rows=[]
    #ratings.each {|r| variance_rows << r.sigma**2 }
    #variance_matrix=Matrix.diagonal *variance_rows 
    #rotated_a_matrix=lambda do
    #    mat=[]
    #    t=0
    #    rating_groups.clip.zip(rating_groups.drop(1)).each_with_index do |y,r|
    #      rline=[]
    #      cur=y[0]
    #      nex=y[1]
    #      z=0
    #      (t..t+cur.length).each do |x|
    #        rline << 1
    #        t+=1
    #        z=x
    #      end
    #      z+=1
    #      (z..z+nex.length).each do |x|
    #        rline << -1
    #      end
    #      mat << rline
    #    end
    #    mat
    #end
    #rotated_a_matrix=Matrix[rotated_a_matrix.call]
    #a_matrix = rotated_a_matrix.transpose()
    #_ata = (@beta ** 2) * rotated_a_matrix * a_matrix
    #pp _ata
  #end
end