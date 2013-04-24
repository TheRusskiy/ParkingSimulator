require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class ParkingLotTest < MiniTest::Unit::TestCase
  require '../src/road/road'
  require '../src/road/parking_spot'
  require '../src/road/parking_road'
  require '../src/road/car'
  require '../src/road/distance_calculator'
  require '../src/road/coordinate'
  require '../src/road/parking_lot'
  require '../src/road/parking_spot'

  def setup
    @c0 = Coordinate.new(70, 70)
    @c1 = Coordinate.new(60, 60)
    @c2 = Coordinate.new(60, 0)
    @c3 = Coordinate.new(0, 0)
    @c4 = Coordinate.new(0, 60)
    @entrance = Road.new(@c0, @c1)
    @road1 = ParkingRoad.new(@c1, @c2)
    @road2 = ParkingRoad.new(@c2, @c3)
    @road3 = ParkingRoad.new(@c3, @c4)
    @lot = ParkingLot.new
    @lot.set_entrance @entrance
    @entrance.extension=@road1
    @road1.extension=@road2
    @road2.extension=@road3
    @lot.add_road_segment @road1
    @lot.add_road_segment @road2
    @lot.add_road_segment @road3
  end

  def teardown
    # Do nothing
  end

  def test_parking_spot_count
    spot_length = $SPOT_LENGTH
    assert_equal @road1.spot_count,
                 (DistanceCalculator.distance_between(@c1, @c2)-spot_length*2)/spot_length*2
  end

  def test_lot_spot_count
    assert_equal @lot.spot_count, @road1.spot_count+@road2.spot_count+@road3.spot_count
  end

  def test_parking_road_has_spots
    spots = @road1.spots
    assert_equal spots.length, @road1.spot_count
  end

  def test_car_has_assigned_spot
    car = Car.new
    car.wants_to_park 1
    spot_count_before = @lot.free_spot_count
    assert car.assigned_spot.nil?
    car.move_to @road1
    refute car.assigned_spot.nil?
    assert_equal spot_count_before - 1, @lot.free_spot_count
  end

  def test_car_can_be_parked
    car = Car.new
    car.wants_to_park 1
    car.move_to @road1
    assert @road1.has_car? car
    refute car.assigned_spot.has_car? car

    car.move_by 1
    assert @road1.has_car? car
    refute car.assigned_spot.has_car? car

    car.move_by $SPOT_LENGTH*2-1
    refute @road1.has_car? car
    assert car.assigned_spot.has_car? car
  end

  def test_to_2nd_if_1st_filled
    car = Car.new
    car.wants_to_park 1
    spots = @road1.spots
    spots.each do |spot|
      Car.new.move_to spot
    end
    car.move_to @road1
    assert_same @road2, car.assigned_spot.road
  end

  def test_gets_spot_when_enters
    car = Car.new
    car.wants_to_park 1
    assert car.assigned_spot.nil?
    car.move_to @entrance
    refute car.assigned_spot.nil?
  end

  def test_does_not_have_free_spots
    lot = ParkingLot.new
    entrance = Road.new(@c0, @c1)
    parking_road = ParkingRoad.new(@c1, @c2)
    entrance.extension=parking_road
    lot.set_entrance entrance
    lot.add_road_segment parking_road
    assert lot.has_free_spots?

    spots = parking_road.spots
    spots.each do |spot|
      Car.new.move_to spot
    end
    refute lot.has_free_spots?
  end

  def test_car_cant_move_to_full_lot
    lot = ParkingLot.new
    entrance = Road.new(@c0, @c1)
    parking_road = ParkingRoad.new(@c1, @c2)
    entrance.extension=parking_road
    lot.set_entrance entrance
    lot.add_road_segment parking_road

    spots = parking_road.spots
    spots.each do |spot|
      Car.new.move_to spot
    end
    refute lot.has_free_spots?

    car = Car.new
    road = Road.new
    car.move_to road
    road.add_parking_entrance entrance, 20
    assert road.has_car? car

    car.move_by 30
    assert road.has_car? car
    refute entrance.has_car? car
    refute parking_road.has_car? car
  end

  def test_waits_n_turns
    turns = 10
    car = Car.new
    car.wants_to_park(turns)
    spot = ParkingSpot.new(@c3, @c3.new_with_x(@c3.x+5), @road1, 0, true)
    car.assigned_spot = spot
    car.move_to spot
    refute car.assigned_spot.nil?
    assert spot.has_car? car

    (turns-1).times do
      car.move_by(1)
    end
    refute car.assigned_spot.nil?
    assert spot.has_car? car
    assert car.wants_to_park?

    car.move_by(1)
    assert car.assigned_spot.nil?
    refute spot.has_car? car
    refute car.wants_to_park?
    refute spot.assigned_car
  end

  def test_cant_leave_if_occupied
    car = Car.new
    car.wants_to_park 1
    car.move_to @road1
    car.move_by $SPOT_LENGTH*2
    refute @road1.has_car? car
    assert car.assigned_spot.has_car? car

    spot = car.assigned_spot
    car2 = Car.new
    car2.move_to @road1
    car2.move_by $SPOT_LENGTH

    car.move_by(1)
    refute @road1.has_car? car
    assert spot.has_car? car

    car2.move_by $SPOT_LENGTH
    car.move_by(1)
    assert @road1.has_car? car
    refute spot.has_car? car
  end

end
      