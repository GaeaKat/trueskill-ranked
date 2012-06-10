module TrueSkill

class SumFactor < Factor
  @sum=nil
  @terms=nil
  @coeffs=nil
  def initialize(sum_var,term_vars,coeffs)
    super([sum_var]+term_vars)
    @sum=sum_var
    @terms=term_vars
    @coeffs=coeffs
  end
  
  def down
   vals=@terms
   @msgs=[]
   @vals.each do |var|
    @msgs << var[self]
   end
   update(@sum,@vals,msgs,@coeffs)
  end 
  
  def up(index=0)
    coeff=@coeffs[index]
    @x=0
  end
end

end