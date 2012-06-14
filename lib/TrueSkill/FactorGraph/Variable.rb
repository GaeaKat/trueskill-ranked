
class Variable < Gaussian

  
  @delta=nil
  def initialize()
    super()
    @messages={}
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
      message=Gaussian.new(nil,nil,pi,tau)
    end
    old_message=self[factor]
    self[factor]=message
    return set(self/old_message*message)
  end
  
  def update_value(factor,pi=0,tau=0,value=nil)
    if  value.nil?
      value=Gaussian.new(nil,nil,pi,tau)
    end
    old_message=self[factor]
    self[factor]=value*old_message/self
    return set(value)
  end
  
  def [](y)
    @messages[y]
  end
  
  def []=(y,value)
    @messages[y]=value
  end
  def to_s
    return "<Variable "+self.object_id.to_s+" mu="+self.mu.to_s+" sigma= "+self.sigma.to_s+">"
  end
end

