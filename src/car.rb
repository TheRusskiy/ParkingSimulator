
class Car
  attr_accessor :coordinate

  def initialize()

  end

  def move_to(placement)
    @placement=placement
    @placement.add_car(self)
    @coordinate=@placement.get_coordinate(:start)
  end

  def get_placement
    return @placement
  end

  def move_by(space)
    @placement.move_car_by(self, space)
  end
end