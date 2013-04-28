require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class ParkingEntranceTest < MiniTest::Unit::TestCase
  require '../src/road/road'
  require '../src/road/car'
  require '../src/road/parking_lot'
  require '../src/road/distance_calculator'
  require '../src/road/coordinate'
  def setup
    @road = Road.new
    @car = Car.new
    @entrance = Road.new
    @road.add_parking_entrance(@entrance,40)
    @car.move_to @road
    lot=FakeLot.new
    @entrance.parking_lot=lot
  end

  def teardown
    # Do nothing
  end

  def test_road_has_parking_entrance
    p2 = @road.parking_entrance
    assert_same @entrance, p2
    assert_equal @road.distance_to_parking_entrance, 40
  end

  def test_car_wants_to_park
    refute @car.wants_to_park?
    @car.wants_to_park 1
    assert @car.wants_to_park?
  end

  def test_goes_to_parking
    @car.wants_to_park 1
    @car.move_by(30)
    assert @road.has_car? @car
    refute @entrance.has_car? @car
    @car.move_by(10)
    refute @road.has_car? @car
    assert @entrance.has_car? @car
  end

  def test_car_does_not_move_if_occupied
    @car.wants_to_park 1
    @car.move_by(40)
    refute @road.has_car? @car
    car2=Car.new
    car2.wants_to_park 1
    car2.move_to @road
    car2.move_by(40)
    assert @road.has_car? car2
    refute @entrance.has_car? car2
    @car.move_by @car.length+@road.safe_gap
    car2.move_by 1
    refute @road.has_car? car2
    assert @entrance.has_car? car2
  end

  class FakeLot
    def has_free_spots?
      true
    end
    def assign_spot(car)
      #empty
    end
  end

end
      