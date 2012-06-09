module TrueSkill
  include 'Mathematics/general.rb'
  include 'Mathematics/guassian.rb'
  class Rating < Gaussian
  attr_accessor :exposure
    def initialize(mu=nil,sigma=nil)
      if mu.is_a? list or mu.is_a? tuple
        mu,sigma=mu
      end
      if mu.nil?
        mu=g().mu
      end
      if sigma.nil?
        sigma=g().sigma
      end
      super(mu,sigma)
    end

    def exposure
      return mu-3*sigma
    end
    def to_s
      return "[mu="+mu.to_s+",sigma="+sigma.to_s+"]"
    end
  end
end