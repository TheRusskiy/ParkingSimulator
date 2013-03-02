class Road
  require '../src/state'
  require '../src/distance_calculator'
  require 'awesome_print'
  require '../src/accident'
  include Math
  attr_reader :length
  attr_reader :cars
  def initialize(c1=Coordinate.new(100, 100), c2=Coordinate.new(0, 100))
    @cars = Array.new
    @coordinates = Hash.new
    @coordinates[:start] = c1
    @coordinates[:end] = c2
    @length=DistanceCalculator.distance_between(c1, c2)
    @slope = DistanceCalculator.slope_between(c1, c2)
    @koef =  Math.sqrt(1.0/(1+@slope**2))
  end

  def get_state(car)
    state= State.new
    beetween_car_and_end = DistanceCalculator.distance_between(car.coordinate, @coordinates[:end])
    state.set_available_space(beetween_car_and_end)
    if @cars.length>1
      state.set_available_space distance_to_closest_car_for(car)
    end
    return state
  end


  def add_car(car)
    for existing_car in @cars
      raise Accident unless DistanceCalculator.is_safe_between?(existing_car, car)
    end
    @cars << car
    car.coordinate=@coordinates[:start]
  end

  def has_car?(car)
    @cars.include?(car)
  end

  def move_car_by(car, by_space)
    dx=-by_space*@koef
    dy=dx*@slope
    if by_space>=DistanceCalculator.distance_between(car.coordinate, @coordinates[:end])
      @cars.delete(car)
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