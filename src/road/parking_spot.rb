class ParkingSpot
  attr_reader :road
  attr_reader :is_left
  attr_reader :angle
  attr_reader :coordinate
  attr_accessor :number
  attr_accessor :speed
  def initialize(entrance_coordinate, coordinate, owning_road, angle, is_left)
    @angle=angle
    @coordinates=Hash.new
    @coordinate=entrance_coordinate # yeah, yeah, redundant... for the sake of attr_reader naming
    @coordinates[:end]=coordinate
    @coordinates[:start]=entrance_coordinate
    @car = nil
    @assigned_car = nil
    @road = owning_road
    @is_left=is_left
    @number = 0
    @speed=1
  end

  def get_state(car)
    state= car.state
    state.set_available_space 0
    return state
  end

  def move_car_by(car, by_space)
    if not car.eql? @car;
      raise Exception.new('Car inside spot and car to be moved are different') end
    if car.wants_to_park?
      car.turn
    end
    exit_is_free = @road.free_space?(car.length, @coordinates[:start])
    if exit_is_free and not car.wants_to_park?
      #car.move_to @road
      car.placement=@road
      car.coordinate=@coordinates[:start]
      @road.include_car car

      @car.assigned_spot = nil
      if @car.respond_to?(:assigned_spot_2)
        @car.assigned_spot_2.assigned_car=nil
      end
      @car=nil
      @assigned_car=nil
    end
  end


  def coordinates(coord_name)
    @coordinates[coord_name]
  end

  def occupied?
    not (@car.nil? and @assigned_car.nil?)
  end

  def assigned_car=(car)
    #car itself uses this method
    @assigned_car=car
  end

  def assigned_car
    @assigned_car
  end

  def assigned?
    not @assigned_car.nil?
  end

  def add_car(car, starting_coordinate)
    @car=car
    #if is_left coord = @coordinates[:start].with_x
    coord = @coordinates[:end]
    @car.coordinate=coord
  end

  def has_car?(car)
    @car.eql? car
  end

end