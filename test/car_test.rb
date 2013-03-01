require 'minitest/autorun'
require "minitest/reporters"
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class CarTest < MiniTest::Unit::TestCase
  require '../src/car'
  require '../src/road'
  require '../src/coordinate'

  def setup
    @car = Car.new
    @road = Road.new
    @car.move_to(@road)
    @state = @road.get_state(@car)
  end

  def teardown
    # Do nothing
  end

  def test_initialization
    assert_kind_of(Car, @car)
  end

  def test_car_can_move_to_road
    assert_equal(@car.get_placement, @road)
  end

  def test_available_space
    assert_equal @state.get_available_space, @road.get_length
  end

  def test_has_coordinate
    assert_nil Car.new.coordinate
  end

  def test_gets_road_coordinate
    assert(@car.coordinate, "Test if nil")
    assert_equal @road.get_coordinate(:start), @car.coordinate
  end

  def test_available_space_for_2_cars
    @car.move_by(10)
    @car2=Car.new
    @car2.move_to(@road)
    @state = @road.get_state(@car2)
    assert_in_delta @state.get_available_space, 10, 0.01
  end

  def test_car_can_move
    previous_space = @state.get_available_space
    @car.move_by(10)
    @state =  @road.get_state(@car)
    assert_equal previous_space-10, @state.get_available_space
  end
end
