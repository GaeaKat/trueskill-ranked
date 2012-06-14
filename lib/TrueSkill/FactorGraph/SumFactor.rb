
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
   vals.each do |var|
    msgs << var[self]
   end
   update(@sum,vals,msgs,@coeffs)
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
    vals.each do |var|
      msgs << var[self]
    end
    return update(@terms[index],vals,msgs,coeffs)
  end
  
  def update(var,vals,msgs,coeffs)
    size=coeffs.length-1
    divs=[]
    (0..size).each do |x|
      vl=vals[x]
      ms=msgs[x]
      divs << vl/ms
    end
    pisum=[]
    (0..size).each do |x|
      pisum << coeffs[x]**2/divs[x].pi
    end
    pi=1.0/pisum.inject{|sum,x| sum + x }
    
    tausum=[]
    (0..size).each do |x|
      tausum << coeffs[x]*divs[x].mu
    end
    tau=pi*tausum.inject{|sum,x| sum + x }
    return var.update_message(self,pi,tau)
  end
  def to_s
    return "<SumFactor "+self.object_id.to_s+">"
  end
end

