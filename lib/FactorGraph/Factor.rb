module TrueSkill

class Factor
  attr_accessor :vars
  @vars=nil
  def initialize(vars)
    @vars=vars
    @vars.each do |var|
      var[self]=Gaussian.new
    end
      
  end

  def var
    @vars[0]
  end
end

end