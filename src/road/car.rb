class Car
  require_relative 'coordinate'
  require_relative 'state'
  attr_accessor :coordinate
  attr_accessor :placement
  attr_reader :state
  attr_reader :length

  def initialize
    @length=4
    @state = State.new
    @wants_to_park = false
  end

  def move_to(placement)
    @placement=placement
    @coordinate=@placement.coordinates(:start)
    @placement.add_car(self)
  end

  def move_by(space)
    state = @placement.get_state(self)
    if state.get_available_space<space; space = state.get_available_space end
    @placement.move_car_by(self, space)
    #if @placement; @state=@placement.get_state(self) end
  end

  def wants_to_park?
    @wants_to_park
  end

  def wants_to_park=(value)
    @wants_to_park=value
  end

end