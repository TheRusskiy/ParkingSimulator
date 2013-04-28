class Road
  require_relative 'state'
  require_relative 'distance_calculator'
  require_relative '../exceptions/accident_exception'
  require_relative '../exceptions/car_added_twice_exception'
  require 'awesome_print'
  include Math
  attr_reader :length, :cars, :angle, :safe_gap
  attr_accessor :parking_lot

  def initialize(c1=Coordinate.new(100, 100), c2=Coordinate.new(0, 100))
    @cars = Array.new
    @coordinates = Hash.new
    @coordinates[:start] = c1
    @coordinates[:end] = c2
    @length=DistanceCalculator.distance_between(@coordinates[:start], @coordinates[:end])
    @angle = DistanceCalculator.angle_between(c1, c2)
    @sinus = Math.sin(@angle)
    @cosine = Math.cos(@angle)
    @safe_gap=0
    @coordinate_to_connect=nil
  end

  def get_state(car)
    state= car.state
    #beetween_car_and_end = DistanceCalculator.distance_between(car.coordinate, @coordinates[:end])
    #state.set_available_space(beetween_car_and_end)
    #if @cars.length>1
      state.set_available_space distance_to_closest_car_for(car)
    #end
    return state
  end

  def distance_from_beginning(car)
    DistanceCalculator.distance_between(car.coordinate, @coordinates[:start])
  end

  def free_space?(free_space, coordinate = nil)
    coordinate||=@coordinates[:start]
    #if coordinate.is_a? Fixnum #method overload
    #  free_space=coordinate;
    #  coordinate = @coordinates[:start]
    #end
    for existing_car in @cars
      return false unless DistanceCalculator.is_safe_between?(existing_car, coordinate, free_space+@safe_gap)
    end
    return true
  end

  def add_car(car, starting_coordinate=@coordinates[:start])
    include_car car
    car.coordinate=starting_coordinate
    car.state.rotation = @angle
    assign_parking_spot(car)
  end

  def include_car(car)
    if @cars.include?(car); raise CarAddedTwiceException end
    for existing_car in @cars
      raise AccidentException.new(existing_car, car) unless DistanceCalculator.is_safe_between?(existing_car, car, car.length)
    end
    @cars << car
  end

  def has_car?(car)
    @cars.include?(car)
  end

  def move_car_by(car, by_space)
    move_car(by_space, car)
    if car.wants_to_park? and @parking_entrance and ((distance_from_beginning car)-distance_to_parking_entrance>=0) and @parking_entrance.parking_lot.has_free_spots?(car.required_spots)
      move_car_to(car, @parking_entrance)
    elsif DistanceCalculator.distance_between(car.coordinate, @coordinates[:start])>=@length
      move_car_to(car, @extension, @coordinate_to_connect)
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

  def coordinate_at(length)
    dx = length*@cosine
    dy = length*@sinus
    Coordinate.new(@coordinates[:start].x+dx, @coordinates[:start].y+dy)
  end

  def connect_at(road, length)
    @extension=road
    @coordinate_to_connect = road.coordinate_at(length)
    @length=DistanceCalculator.distance_between(@coordinate_to_connect, @coordinates[:start])
  end

  def to_s
    'start:'+@coordinates[:start].inspect+', end:'+@coordinates[:end].inspect
  end

  #____P_R_I_V_A_T_E_____#
  private
  def distance_to_closest_car_for(my_car)
    my_car_to_end=DistanceCalculator.distance_between(my_car.coordinate, @coordinates[:end])
    current_distance=my_car_to_end
    closest_car=nil
    for other_car in @cars do
      other_car_to_end = DistanceCalculator.distance_between(other_car.coordinate, @coordinates[:end])
      ## if END < CurrDist < OtherCar < MyCar : CurrDist=OtherCar
      #if other_car!=my_car and other_car_to_end<my_car_to_end and other_car_to_end>current_distance
      #  current_distance=other_car_to_end+my_car.length+other_car.length+@safe_gap # '+' because method returns '-current_distance'
      #end
      if other_car!=my_car and other_car_to_end<my_car_to_end and my_car_to_end-other_car_to_end<=current_distance
        current_distance=my_car_to_end-other_car_to_end
        closest_car=other_car
      end
    end
    if closest_car
      current_distance=current_distance-my_car.length-@safe_gap
    end
    return current_distance
  end

  def move_car(by_space, car)
    if car.stopped?
      return
    end
    dx = by_space*@cosine
    dy = by_space*@sinus
    car.coordinate=Coordinate.new(car.coordinate.x+dx, car.coordinate.y+dy)
  end

  def move_car_to(car, placement, starting_coordinate=nil)
    if placement;
      if not placement.free_space?(car.length+@safe_gap, starting_coordinate)
        car.stopped=true
        return
      end
      car.stopped=false
      car.move_to placement, starting_coordinate
    end
    @cars.delete(car)
    car.placement=placement
    car.coordinate=starting_coordinate unless starting_coordinate.nil?
  end

  def assign_parking_spot(car)
    if car.wants_to_park? and car.assigned_spot.nil? and @parking_lot
      @parking_lot.assign_spot(car)
    end
  end


end