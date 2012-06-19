class Matrix

include Enumerable
  @size=nil
  @base=nil
  def initialize(src=nil,width=nil,height=nil,options={})
    if options.include? :func
      f,src=options[:func],{}
      @size=[width,height]
      if width.nil?
        @size[0]=Proc.new do |w|
          @size[0]=w
        end
      end
      if height.nil?
        @size[1]=Proc.new do |h|
          @size[1]=h
        end
      end
      arr=Array(f.call(@size[0],@size[1]))
      #pp arr
      arr.each do|v,val|
        src[[v[0],v[1]]]=val
      end
      width=@size[0]
      height=@size[1]
    end
    if src.is_a? Array
      unique_col_sizes=Set.new(src.map { |x| x.length })
      if not unique_col_sizes.length==1
        raise "Must be a rectangular range of numbers"
      end
      num=true
      src.flatten.each { |x| if not x.is_a? Numeric then num=false end }
      if num==false
        raise "Must be a rectangular range of numbers"
      end 
      two_dimensional_array=src
    elsif src.is_a? Hash
      if width.nil? or height.nil?
        w,h=0,0
        src.each_key do |x|
          r=x[0]
          c=x[1]
          if width.nil?
            w=[w,r+1].max
          end
          if height.nil?
            h=[h,c+1].max
          end
        end
        if width.nil?
          width=w
        end
        if height.nil?
          height=h
        end
      end
      two_dimensional_array=[]
      (0...height).each do |r|
        row=[]
        (0...width).each do |c|
          if src.include? [r,c]
            val=src[[r,c]]
          else
            val=0
          end
          row << val 
        end
        two_dimensional_array << row
      end
    end
    @base=two_dimensional_array  
  end
  
  def width
    return @base[0].length
  end
  
  def height
    return @base.length
  end
  def each(&block)
    return
  end
  def [](r,c)
    return @base[r][c]
  end
  def []=(r,c,val)
    @base[r][c]=val
  end

  def transpose
    w,h=width,height
    src={}
    (0...w).each do |c|
      (0...h).each do |r|
        src[[c,r]]=@base[r][c]
      end
    end
    return Matrix.new(src,w,h)
  end
  def minor(row_n,col_n)
    w,h=width,height
    if row_n < 0  or row_n >= w or col_n < 0 or col_n >= h
      raise 'invalid row or column number'
    end 
    two_dimensional_array=[]
    (0...h).each do |r|
      if r==row_n
        next
      end
      row=[]
      (0...w).each do |c|
        if c==col_n
          next
        end
        row << @base[r][c]
      end
      two_dimensional_array << row
    end
    return Matrix.new(two_dimensional_array)
  end
    def row(r)
    @base[r]
  end
  def setrow(r,val)
    @base[r]=val
  end
  def determinant
    w,h=width,height
    if not w==h
      raise "Must be a square matrix"
    end
    tmp,rv=self.clone,1
    (w-1).downto(1) do |c|
      p=[]
      (0..c).each {|r| p << [tmp[r,c].abs,r]}
      pivot,r=p.max
      pivot=tmp[r,c]
      if pivot.nil?
        return 0
      end

      val=tmp.row(r)
      tmp.setrow(r,tmp.row(c))
      
      tmp.setrow(c,val)
      if not r==c
        rv=-rv
      end
      rv*=pivot
      fact=-1.0/pivot
      (0...c).each do |r|
        f=fact*tmp[r,c]
        (0...c).each do |x|
          tmp[r,x]+=f*tmp[c,x]
        end
      end
    end
    return rv*tmp[0,0]
  end

  def adjucate
    w,h=width,height
    if h==2
      a,b=self[0,0],self[0,1]
      c,d=self[1,0],self[1,1]
      return Matrix.new([[d,-b],[-c,a]])
    else
      src={}
      (0...height).each do |r|
        (0...width).each do |c|
          v=0
          if (r+c) % 2==1
            v=-1
          else
            v=1
          end
          src[[r,c]]=self.minor(r,c).determinant*v
        end
      end
      return Matrix.new(src,w,h)
    end
  end  
  def clone
    rows=[]
    @base.each do |x|
      rows << x.clone
    end
    Matrix.new(rows)
  end
end