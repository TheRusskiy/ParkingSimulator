require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class CarTest < MiniTest::Unit::TestCase
  require '../src/road/car'
  require '../src/road/road'
  require '../src/road/coordinate'

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
    assert_equal(@car.placement, @road)
  end

  def test_available_space
    assert_equal @state.get_available_space, @road.length
  end

  def test_has_coordinate
    assert_nil Car.new.coordinate
  end

  def test_gets_road_coordinate
    @car.coordinate.wont_be_nil
    assert_equal @road.get_coordinate(:start), @car.coordinate
  end


  def test_car_can_move
    previous_space = @state.get_available_space
    @car.move_by(10)
    @state =  @road.get_state(@car)
    assert_equal previous_space-10, @state.get_available_space
  end

  def test_car_has_state
    @car.state.wont_be_nil
  end
end
