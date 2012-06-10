module TrueSkill
  require 'Mathematics/general.rb'
  require 'Mathematics/guassian.rb'
  require 'general'
  class Rating < Gaussian
  attr_accessor :exposure
    def initialize(mu=nil,sigma=nil)
      if mu.kind_of?(Array)
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