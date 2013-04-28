class Car
  require_relative 'coordinate'
  require_relative 'state'
  attr_accessor :coordinate
  attr_accessor :placement
  attr_reader :state
  attr_reader :length
  attr_reader :assigned_spot
  $car_length=4

  def initialize
    @assigned_spot = nil
    @length=$car_length
    @state = State.new
    @turns_to_wait = 0
    @stopped = false
  end

  def move_to(placement, starting_coordinate=nil)
    @placement=placement
    starting_coordinate||=@placement.coordinates(:start)
    @coordinate=starting_coordinate
    @placement.add_car(self, @coordinate)
  end

  def move_by(space)
    state = @placement.get_state(self)
    if state.get_available_space<space; space = state.get_available_space end
    if space<0; space=0; end;
    @placement.move_car_by(self, space)
    #if @placement; @state=@placement.get_state(self) end
  end

  def wants_to_park?
    @turns_to_wait>0
  end

  def wants_to_park(value)
    @turns_to_wait=value
  end

  def turn
    @turns_to_wait=@turns_to_wait - 1
  end

  def stopped?
    @stopped
  end

  def stopped=(value)
    @stopped=value
  end

  def assigned_spot=(spot)
    @assigned_spot=spot
    if spot; spot.assigned_car= self; end
  end

end

class Truck < Car
  $truck_length=8
  def initialize
    super
    @length=$truck_length
  end
end