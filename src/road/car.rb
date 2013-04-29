class Car
  require_relative 'coordinate'
  require_relative 'state'
  attr_accessor :coordinate
  attr_accessor :placement
  attr_reader :state
  attr_reader :length
  attr_reader :width
  attr_reader :assigned_spot
  attr_reader :required_spots
  $car_length=4

  def initialize
    @assigned_spot = nil
    @length=$car_length
    @state = State.new
    @turns_to_wait = 0
    @stopped = false
    @required_spots=1
    @width=2
    if rand(2)==0;
      @model='domestic'
    else
      @model='imported'
    end
  end

  def getModel
    @model
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

  def move()
    if @placement; move_by(@placement.speed) end
  end

  def wants_to_park?
    @turns_to_wait>0
  end

  def wants_to_park_time
    @turns_to_wait
  end

  def wants_to_park(value)
    @turns_to_wait=value
  end

  def turn
    turns = @cashier ? @cashier.time_scale : 1
    @turns_to_wait=@turns_to_wait - turns
    if @cashier
      @cashier.bill(self, turns)
    end
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
    @assigned_spot_2=nil
    @required_spots=2
    @width=3
    @model='truck'
  end

  def assigned_spot_2
    @assigned_spot_2
  end

  def assigned_spot_2=(value)
    @assigned_spot_2=value
    @assigned_spot_2.assigned_car= self;
  end
end