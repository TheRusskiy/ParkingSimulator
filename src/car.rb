
class Car
  require '../src/coordinate'
  attr_accessor :coordinate

  def initialize()

  end

  def move_to(placement)
    @placement=placement
    @coordinate=@placement.get_coordinate(:start)
    @placement.add_car(self)
  end

  def get_placement
    return @placement
  end

  def move_by(space)
    @placement.move_car_by(self, space)
  end
end