class Gaussian
  attr_accessor :pi,:tau,:mu,:sigma
  @pi=nil
  @tau=nil
  def initialize(mu=nil,sigma=nil,pi=0,tau=0)
    if not mu.nil?
      if sigma.nil? or sigma==0.0
        raise "a variance(sigma^2) should be greater than 0"
      end
      pi=sigma**-2
      tau=pi*mu
    end
    @pi=pi
    @tau=tau
  end
  
  def mu
    @tau/@pi
  end
  
  def sigma
    if @pi.nil? or @pi==0
      return 1.0/0
    end
    return Math.sqrt(1/@pi)
  end
  def *(y)
    pi=@pi+y.pi
    tau=@tau+y.tau
    return Gaussian.new(nil,nil,pi,tau)
  end
  def /(y)
    pi=@pi-y.pi
    tau=@tau-y.tau
    return Gaussian.new(nil,nil,pi,tau)
  end
end

