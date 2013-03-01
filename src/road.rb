class Road
  require '../src/state'
  require '../src/distance_calculator'
  include Math
  def initialize(c1=Coordinate.new(100, 100), c2=Coordinate.new(0, 100))
    @cars = Array.new
    @coordinates = Hash.new
    @coordinates[:start] = c1
    @coordinates[:end] = c2
    @length=DistanceCalculator.distance_between(c1, c2)
    @slope = DistanceCalculator.slope_between(c1, c2)
    @koef =  Math.sqrt(1/(1+@slope**2))
  end

  def get_state(car)
    state= State.new
    beetween_car_and_end = DistanceCalculator.distance_between(car.coordinate, @coordinates[:end])
    state.set_available_space(beetween_car_and_end)
    return state
  end

  def get_length
    @length
  end

  def add_car(car)
    @cars << car
    car.coordinate=@coordinates[:start]
  end

  def has_car?(car)
    @cars.include?(car)
  end

  def move_car_by(car, by_space)
    dx=-by_space*@koef
    dy=dx*@slope
    car.coordinate=Coordinate.new(car.coordinate.get_x+dx, car.coordinate.get_y+dy)
  end

  def get_coordinate(coord_name)
    @coordinates[coord_name]
  end
end