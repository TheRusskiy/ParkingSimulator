class Coordinate
  def initialize(x, y)
    @x=x
    @y=y
  end

  def x
    @x
  end

  def y
    @y
  end

  def new_with_x(x)
    return Coordinate.new(x, @y)
  end

  def new_with_y(y)
    return Coordinate.new(@x, y)
  end

  def to_s
    '('+Integer(x).to_s+':'+Integer(y).to_s+')'
  end

end