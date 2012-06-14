class TruncateFactor < Factor
  @v_func=nil
  @w_func=nil
  @draw_margin=nil
  
  def initialize(var,v_func,w_func,draw_margin)
    super([var])
    @v_func=v_func
    @w_func=w_func
    @draw_margin=draw_margin
  end
  
  
  def up()
    val=var
    msg=var[self]
    div=val/msg
    sqrt_pi=Math.sqrt(div.pi)
    
    v=@v_func.call(div.tau/sqrt_pi,@draw_margin*sqrt_pi)
    w=@w_func.call(div.tau/sqrt_pi,@draw_margin*sqrt_pi)
    
    denom=(1.0-w)
    pi=div.pi/denom
    tau=(div.tau+sqrt_pi*v)/denom
    return var.update_value(self,pi,tau)
  end  
end
