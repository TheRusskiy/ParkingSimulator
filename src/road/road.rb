class Road
  require_relative 'state'
  require_relative 'distance_calculator'
  require_relative '../exceptions/accident_exception'
  require_relative '../exceptions/car_added_twice_exception'
  require 'awesome_print'
  include Math
  attr_reader :length
  attr_reader :cars, :slope, :angle

  def initialize(c1=Coordinate.new(100, 100), c2=Coordinate.new(0, 100))
    @cars = Array.new
    @coordinates = Hash.new
    @coordinates[:start] = c1
    @coordinates[:end] = c2
    @length=DistanceCalculator.distance_between(c1, c2)
    @angle = DistanceCalculator.angle_between(c1, c2)
    @sinus = Math.sin(@angle)
    @cosine = Math.cos(@angle)
  end


  def get_state(car)
    state= car.state
    beetween_car_and_end = DistanceCalculator.distance_between(car.coordinate, @coordinates[:end])
    state.set_available_space(beetween_car_and_end)
    if @cars.length>1
      state.set_available_space distance_to_closest_car_for(car)
    end
    return state
  end

  def distance_from_beginning(car)
    DistanceCalculator.distance_between(car.coordinate, @coordinates[:start])
  end

  def free_space?()
    for existing_car in @cars
      return false unless DistanceCalculator.is_safe_between?(existing_car, @coordinates[:start])
    end
    return true
  end

  def add_car(car)
    if @cars.include?(car); raise CarAddedTwiceException end
    for existing_car in @cars
      raise AccidentException unless DistanceCalculator.is_safe_between?(existing_car, car)
    end
    @cars << car
    car.coordinate=@coordinates[:start]
    car.state.rotation = @angle
  end

  def has_car?(car)
    @cars.include?(car)
  end

  def move_car_by(car, by_space)
    if car.wants_to_park? and @parking_entrance and ((distance_from_beginning car)+by_space-distance_to_parking_entrance>=0)
      move_car_to_parking(car)
    elsif by_space>=DistanceCalculator.distance_between(car.coordinate, @coordinates[:end])
      move_car_to_extension(car)
    else
      dx = by_space*@cosine
      dy = by_space*@sinus
      car.coordinate=Coordinate.new(car.coordinate.x+dx, car.coordinate.y+dy)
    end
  end

  def coordinates(coord_name)
    @coordinates[coord_name]
  end

  def extension=(extension)
    @extension=extension
  end

  def extension
    @extension
  end

  def add_parking_entrance(entrance, distance_from_start)
    @parking_entrance=entrance
    @parking_entrance_distance = distance_from_start
    #dx = @parking_entrance_distance*@cosine
    #dy = @parking_entrance_distance*@sinus
    #@parking_entrance.set_start(Coordinate.new(dx+@coordinates[:start].x, dy+@coordinates[:start].y))
  end

  def parking_entrance
    @parking_entrance
  end

  def distance_to_parking_entrance
    @parking_entrance_distance
  end



  #____P_R_I_V_A_T_E_____#
  private
  def distance_to_closest_car_for(my_car)
    my_car_to_end=DistanceCalculator.distance_between(my_car.coordinate, @coordinates[:end])
    current_distance=0
    for other_car in @cars do
      other_car_to_end = DistanceCalculator.distance_between(other_car.coordinate, @coordinates[:end])
      # if END < CurrDist < OtherCar < MyCar : CurrDist=OtherCar
      if other_car!=my_car and other_car_to_end<my_car_to_end and other_car_to_end>current_distance
        current_distance=other_car_to_end
      end
    end
    return my_car_to_end - current_distance
  end

  def move_car_to_parking(car)
    car.move_to @parking_entrance
    @cars.delete(car)
  end

  def move_car_to_extension(car)
    @cars.delete(car)
    car.placement=@extension
    if @extension;
      car.move_to @extension
    end
  end

end