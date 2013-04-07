class Coordinate
  def initialize(x, y)
    @x=x
    @y=y
  end

  def get_x
    return @x
  end

  def get_y
    return @y
  end

  def new_with_x(x)
    return Coordinate.new(x, @y)
  end

  def new_with_y(y)
    return Coordinate.new(@x, y)
  end
end