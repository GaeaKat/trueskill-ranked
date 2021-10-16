# frozen_string_literal: true

class Matrix
  include Enumerable
  @size = nil
  @base = nil

  def initialize(src = nil, width = nil, height = nil, options = {})
    if options.include? :func
      f = options[:func]
      src = {}
      @size = [width, height]
      if width.nil?
        @size[0] = proc do |w|
          @size[0] = w
        end
      end
      if height.nil?
        @size[1] = proc do |h|
          @size[1] = h
        end
      end
      arr = Array(f.call(@size[0], @size[1]))
      # pp arr
      arr.each do |v, val|
        src[[v[0], v[1]]] = val
      end
      width = @size[0]
      height = @size[1]
    end
    case src
    when Array
      unique_col_sizes = Set.new(src.map(&:length))
      raise 'Must be a rectangular range of numbers' if unique_col_sizes.length != 1

      num = true
      src.flatten.each { |x| num = false unless x.is_a? Numeric }
      raise 'Must be a rectangular range of numbers' if num == false

      two_dimensional_array = src
    when Hash
      if width.nil? || height.nil?
        w = 0
        h = 0
        src.each_key do |x|
          r = x[0]
          c = x[1]
          w = [w, r + 1].max if width.nil?
          h = [h, c + 1].max if height.nil?
        end
        width = w if width.nil?
        height = h if height.nil?
      end
      two_dimensional_array = []
      (0...height).each do |r|
        row = []
        (0...width).each do |c|
          val = if src.include? [r, c]
                  src[[r, c]]
                else
                  0
                end
          row << val
        end
        two_dimensional_array << row
      end
    end
    @base = two_dimensional_array
  end

  def width
    @base[0].length
  end

  def height
    @base.length
  end

  def each
    nil
  end

  def [](r, c)
    @base[r][c]
  end

  def []=(r, c, val)
    @base[r][c] = val
  end

  def transpose
    w = width
    h = height
    src = {}
    (0...w).each do |c|
      (0...h).each do |r|
        src[[c, r]] = @base[r][c]
      end
    end
    Matrix.new(src, h, w)
  end

  def minor(row_n, col_n)
    w = width
    h = height
    raise 'invalid row or column number' if row_n.negative? || (row_n >= w) || col_n.negative? || (col_n >= h)

    two_dimensional_array = []
    (0...h).each do |r|
      next if r == row_n

      row = []
      (0...w).each do |c|
        next if c == col_n

        row << @base[r][c]
      end
      two_dimensional_array << row
    end
    Matrix.new(two_dimensional_array)
  end

  def row(r)
    @base[r]
  end

  def setrow(r, val)
    @base[r] = val
  end

  def determinant
    w = width
    h = height
    raise 'Must be a square matrix' if w != h

    tmp = clone
    rv = 1
    (w - 1).downto(1) do |c|
      p = []
      (0..c).each { |r| p << [tmp[r, c].abs, r] }
      pivot, r = p.max
      pivot = tmp[r, c]
      return 0 if pivot.nil?

      val = tmp.row(r)
      tmp.setrow(r, tmp.row(c))

      tmp.setrow(c, val)
      rv = -rv if r != c
      rv *= pivot
      fact = -1.0 / pivot
      (0...c).each do |r|
        f = fact * tmp[r, c]
        (0...c).each do |x|
          tmp[r, x] += f * tmp[c, x]
        end
      end
    end
    rv * tmp[0, 0]
  end

  def adjucate
    w = width
    h = height
    if h == 2
      a = self[0, 0]
      b = self[0, 1]
      c = self[1, 0]
      d = self[1, 1]
      Matrix.new([[d, -b], [-c, a]])
    else
      src = {}
      (0...height).each do |r|
        (0...width).each do |c|
          v = 0
          v = if (r + c).odd?
                -1
              else
                1
              end
          src[[r, c]] = minor(r, c).determinant * v
        end
      end
      Matrix.new(src, w, h)
    end
  end

  def inverse
    if (width == 1) && (height == 1)
      Matrix.new([[1.0 / self[0, 0]]])
    else
      (1.0 / determinant) * adjucate
    end
  end

  def coerce(other)
    [self, other]
  end

  def +(other)
    w = width
    h = height
    raise 'Must be same size' unless (w == other.width) && (h == other.height)

    src = {}
    (0...h).each do |r|
      (0...w).each do |c|
        src[[r, c]] = self[r, c] + other[r, c]
      end
    end
    Matrix.new(src, w, h)
  end

  def *(other)
    if other.is_a? Matrix
      w = other.width
      h = height
      # pp w
      # pp h
      # pp other.width
      # pp other.height
      raise 'Must be same size' if width != other.height

      src = {}
      (0...h).each do |r|
        (0...w).each do |c|
          lst = []
          # pp r
          # pp c

          (0...width).each { |x| lst << (self[r, x] * other[x, c]) }
          src[[r, c]] = lst.inject(:+)
        end
      end
    else
      w = width
      h = height
      src = {}
      (0...h).each do |r|
        (0...w).each do |c|
          src[[r, c]] = other * self[r, c]
        end
      end
    end
    Matrix.new(src, w, h)
  end

  def clone
    rows = []
    @base.each do |x|
      rows << x.clone
    end
    Matrix.new(rows)
  end
end
