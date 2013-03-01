require 'minitest/autorun'
require "minitest/reporters"
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class RoadTest < MiniTest::Unit::TestCase
  require '../src/road'
  require '../src/car'
  require '../src/distance_calculator'

  def setup
    @road = Road.new()
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
    assert_in_delta @road.get_length, 141.42, 0.1
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
    car.move_to(@road)
    old_coord=car.coordinate
    @road.move_car_by(car, 20)
    assert_in_delta(DistanceCalculator.distance_between(old_coord, car.coordinate), 20, 0.01)

  end

end
