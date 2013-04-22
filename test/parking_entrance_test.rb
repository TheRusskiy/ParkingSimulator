require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class ParkingEntranceTest < MiniTest::Unit::TestCase
  require '../src/road/road'
  require '../src/road/car'
  require '../src/road/distance_calculator'
  require '../src/road/coordinate'
  def setup
    @road = Road.new
    @car = Car.new
    @proad = Road.new
    @road.add_parking_entrance(@proad,40)
    @car.move_to @road
  end

  def teardown
    # Do nothing
  end

  def test_road_has_parking_entrance
    p2 = @road.parking_entrance
    assert_same @proad, p2
    assert_equal @road.distance_to_parking_entrance, 40
  end

  def test_car_wants_to_park
    refute @car.wants_to_park?
    @car.wants_to_park=true
    assert @car.wants_to_park?
  end

  def test_goes_to_parking
    @car.wants_to_park=true
    @car.move_by(30)
    assert @road.has_car? @car
    refute @proad.has_car? @car
    @car.move_by(10)
    refute @road.has_car? @car
    assert @proad.has_car? @car
  end

  def test_car_does_not_move_if_occupied
    @car.wants_to_park=true
    @car.move_by(40)
    refute @road.has_car? @car
    car2=Car.new
    car2.wants_to_park=true
    car2.move_to @road
    car2.move_by(40)
    assert @road.has_car? car2
    refute @proad.has_car? car2
    @car.move_by 5
    car2.move_by 1
    refute @road.has_car? car2
    assert @proad.has_car? car2
  end

end
      