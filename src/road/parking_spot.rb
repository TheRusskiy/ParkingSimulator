class ParkingSpot
  attr_reader :road
  attr_reader :is_left
  def initialize(entrance_coordinate, coordinate, owning_road, angle, is_left)
    @angle=angle
    @coordinates=Hash.new
    @coordinates[:end]=coordinate
    @coordinates[:start]=entrance_coordinate
    @car = nil
    @assigned_car = nil
    @road = owning_road
    @is_left=is_left
  end

  def get_state(car)
    state= car.state
    state.set_available_space 0
    return state
  end

  def move_car_by(car, by_space)
    if not car.eql? @car; raise Exception('Car inside spot and car to be moved are different') end
    if car.wants_to_park?
      car.turn
    end
    free = @road.free_space?(@coordinates[:start])
    if not car.wants_to_park? and free
      car.move_to @road
      @car.assigned_spot = nil
      @car=nil
      @assigned_car=nil
    end
  end

  def move_car_back_to_road(car)
    if @extension;
      unless @extension.free_space?
        car.stopped=true
        return
      end
      car.stopped=false
      car.move_to @extension
    end
    @cars.delete(car)
    car.placement=@extension
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

  def add_car(car)
    @car=car
  end

  def has_car?(car)
    @car.eql? car
  end

end