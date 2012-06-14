
require_relative 'Factor'
class PriorFactor < Factor
  @val=nil
  @dynamic=0
  def initialize(var,val,dynamic=0)
    super([var])
    @val=val
    @dynamic=dynamic
  end
  
  def down
    sigma=Math.sqrt(@val.sigma**2 + @dynamic ** 2)
    value=Gaussian.new @val.mu,sigma
    var.update_value self,0,0,value
  end 
  def to_s
    return "<PriorFactor "+self.object_id.to_s+">"
  end
end
