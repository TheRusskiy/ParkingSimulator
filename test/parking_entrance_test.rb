require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class ParkingEntranceTest < MiniTest::Unit::TestCase
  require '../src/road/road'
  require '../src/road/car'
  require '../src/road/distance_calculator'
  require '../src/road/coordinate'
  require '../src/road/parking_entrance'
  def setup
    @road = Road.new
    @car = Car.new
    @parking = Road.new
    @road.add_parking_entrance(@parking,40)
    @car.move_to @road
  end

  def teardown
    # Do nothing
  end

  def test_road_has_parking_entrance
    p2 = @road.parking_entrance
    assert_same @parking, p2
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
    refute @parking.has_car? @car
    @car.move_by(10)
    refute @road.has_car? @car
    assert @parking.has_car? @car
  end

end
      