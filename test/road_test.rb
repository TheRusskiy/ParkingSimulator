require 'minitest/autorun'
require 'minitest/reporters'
require 'awesome_print'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class RoadTest < MiniTest::Unit::TestCase
  require '../src/road/road'
  require '../src/road/car'
  require '../src/road/distance_calculator'
  require '../src/road/coordinate'

  def setup
    @road = Road.new()
    @car = Car.new
    @car.move_to(@road)
    @c1 = Coordinate.new(0, 0)
    @c2 = Coordinate.new(100, 100)
  end

  def teardown
    # Do nothing
  end

  def test_initialization
    assert_kind_of(Road, @road)
  end

  def test_can_be_asked_for_state
    assert_respond_to(@road, :get_state)
  end

  def test_has_length
    @road = Road.new(@c1, @c2)
    assert_in_delta @road.length, 141.42, 0.1
  end

  def test_can_add_car
    @road = Road.new
    @car = Car.new
    assert_equal @road.has_car?(@car), FALSE
    @car.move_to(@road)
    assert_equal @road.has_car?(@car), TRUE
  end

  def test_has_coordinate
    @road.get_coordinate(:start)
  end

  def test_move_car_by
    car = Car.new
    road = Road.new
    car.move_to(road)
    old_coord=car.coordinate
    road.move_car_by(car, 20)
    assert_in_delta(DistanceCalculator.distance_between(old_coord, car.coordinate), 20, 0.01)
  end

  def test_available_space_for_2_cars
    @car.move_by(10)
    @car2=Car.new
    @car2.move_to(@road)
    @state = @road.get_state(@car2)
    @state.get_available_space.wont_be_nil
    assert_in_delta @state.get_available_space, 10, 0.01
  end

  def test_available_space_for_2_cars_in_dynamic
    @car.move_by(20)
    @car2=Car.new
    @car2.move_to(@road)
    @state = @road.get_state(@car2)
    assert_in_delta @state.get_available_space, 20, 0.01
    @car2.move_by(10)
    @state = @road.get_state(@car2)
    assert_in_delta @state.get_available_space, 10, 0.01
  end

  def test_cant_be_on_each_other
    @car2=Car.new
    assert_raises (Accident) {@car2.move_to(@road)}
  end

  def test_does_not_depend_on_direction
    car = Car.new
    road = Road.new(Coordinate.new(0, 0), Coordinate.new(100, 200))
    car.move_to(road)
    old_coord=car.coordinate
    road.move_car_by(car, 20)
    assert_in_delta(DistanceCalculator.distance_between(old_coord, car.coordinate), 20, 0.01)
  end

  def test_goes_out_of_road
    @road.move_car_by(@car, @road.length)
    refute_includes(@road.cars, @car)
  end

  def test_same_state_for_car
  # for perfomance!
    state1 = @road.get_state(@car)
    state2 = @road.get_state(@car)
    assert_same(state1, state2)
  end


end
