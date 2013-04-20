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

  def free_space?()
    for existing_car in @cars
      return false unless DistanceCalculator.is_safe_between?(existing_car.coordinate, @coordinates[:start])
    end
    return true
  end

  def add_car(car)
    if @cars.include?(car); raise CarAddedTwiceException; end
    for existing_car in @cars
      raise AccidentException unless DistanceCalculator.is_safe_between?(existing_car.coordinate, car.coordinate)
    end
    @cars << car
    car.coordinate=@coordinates[:start]
    #if @coordinates[:start].get_y - @coordinates[:end].get_y > 0
    #  car.state.rotation = - @angle
    #else
    #  car.state.rotation = @angle
    #end
    car.state.rotation = @angle
  end

  def has_car?(car)
    @cars.include?(car)
  end

  def move_car_by(car, by_space)
    dx = by_space*@cosine
    dy = by_space*@sinus
    if by_space>=DistanceCalculator.distance_between(car.coordinate, @coordinates[:end])
      @cars.delete(car)
      car.placement=nil
    end
    car.coordinate=Coordinate.new(car.coordinate.get_x+dx, car.coordinate.get_y+dy)
  end

  def get_coordinate(coord_name)
    @coordinates[coord_name]
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
end