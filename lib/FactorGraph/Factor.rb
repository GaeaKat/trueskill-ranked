module TrueSkill

class Factor
  @vars=nil
  def initialize(vars)
    @vars=vars
    @vars.each do |var|
      var[self]=Guassian.new
    end
      
  end

  def var
    @vars[0]
  end
end

end