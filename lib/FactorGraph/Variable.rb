module TrueSkill

class Variable < Gaussian

  @messages={}
  @delta=nil
  def initialize()
    super()
  end
  
  def set(val)
    @delta=delta(val)
    @pi=val.pi
    @tau=val.tau
  end
  def delta(other)
    return [(@tau-other.tau).abs,Math.sqrt((@pi-other.pi).abs)].max
  end
  
  def update_message(factor,pi=0,tau=0,message=nil)
    if  message.nil?
      message=Guassian.new(nil,nil,pi,tau)
    end
    @old_message=self[factor]
    self[factor]=message
    return set(self/old_message*message)
  end
end

end