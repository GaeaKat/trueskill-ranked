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
   msgs=[]
   @vals.each do |var|
    msgs << var[self]
   end
   update(@sum,@vals,msgs,@coeffs)
  end 
  
  def up(index=0)
    coeff=@coeffs[index]
    x=0
    coeffs=[]
    @coeffs.each do |c|
      if x!=index
        coeffs << -c/coeff
      end
      x+=1
    end
    coeffs.insert(index,1.0/coeff)
    vals=@terms.dup
    vals[index]=@sum
    msgs=[]
    @vals.each do |var|
      msgs << var[self]
    end
    return update(@terms[index],vals,msgs,coeffs)
  end
  
  def update(var,vals,msgs,coeffs)
    size=coeffs.length
    divs=[]
    (0..size).each do |x|
      divs << vals[x]/msgs[x]
    end
    pisum=[]
    (0..size).each do |x|
      pisum << coeffs[x]**2/divs[x].pi
    end
    pi=1.0/pisum.sum
    
    tausum=[]
    (0..size).each do |x|
      tausum << coeffs[x]*divs[x].mu
    end
    tau=pi*tausum.sum
    return var.update_message(self,pi,tau)
  end
  
end

end