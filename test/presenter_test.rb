require 'minitest/autorun'
require 'minitest/reporters'
require 'Qt'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class PresenterTest < MiniTest::Unit::TestCase
  require '../src/visual/presenter'
  require '../src/visual/parkingview'
  require '../src/road/road'
  require '../src/road/parking_road'
  require '../src/road/parking_spot'

  @app = Qt::Application.new(ARGV)

  def setup
    @presenter = Presenter.new(Qt::GraphicsScene.new)
    @c1 = Coordinate.new(60, 60)
    @c2 = Coordinate.new(0, 0)
    @road = Road.new(@c1, @c2)
    @car = Car.new
    @car.move_to @road
    @entrance = ParkingRoad.new(@c1, @c2)
  end

  def teardown
  #  Do nothing
  end

  def test_can_have_objects_added
    refute(@presenter.contains?(@road))
    @presenter.add(@road)
    assert(@presenter.contains?(@road))
  end

  def test_has_scale
    assert_equal(@presenter.scale, 5)
    @presenter.scale=10
    assert_equal(@presenter.scale, 10)
  end

  def test_coordinate_conversion
    c = Coordinate.new(2, 4)
    @presenter.scale = 10
    assert_equal(@presenter.x(c), 20)
    assert_equal(@presenter.y(c), 40)
  end

  def test_has_scene()
    @presenter.scene.wont_be_nil
  end

  def test_adds_objects_to_scene()
    length1 = @presenter.scene.items.length
    @presenter.add(@car)
    length2 = @presenter.scene.items.length
    assert_equal(length1+2, length2) # + text
  end

  def test_extends_with_drawable()
    @presenter.add(@car)
    @car.draw_item.wont_be_nil
  end

  def test_refresh_items()
    @presenter.add(@car)
    x1 = @car.draw_item.x
    y1 = @car.draw_item.y
    @car.move_by(10)
    x2 = @car.draw_item.x
    y2 = @car.draw_item.y
    assert_equal(x1, x2)
    assert_equal(y1, y2)
    @car.move_by(10)
    @presenter.redraw
    x3 = @car.draw_item.x
    y3 = @car.draw_item.y
    refute_equal(x1, x3)
    refute_equal(y1, y3)
  end

  def test_deletes_car_without_placement
    @presenter.add(@car)
    assert @road.has_car? @car
    assert @presenter.contains? @car
    @car.move_by(100)
    @presenter.redraw
    refute @road.has_car? @car
    refute @presenter.contains? @car
  end

  def test_add_parking_spot
    spot = ParkingSpot.new(@c1, @c2, @entrance, 30, true)
    @presenter.add(spot)
    spot.draw_item.wont_be_nil
  end

  def test_add_parking_road()
    @presenter.add(@entrance)
    @entrance.draw_item.wont_be_nil
    length1 = @presenter.scene.items.length
    @presenter.add(@entrance)
    length2 = @presenter.scene.items.length
    assert_equal length2-length1, @entrance.spot_count+1 #spots+road itself
  end

  def test_add_truck
    truck = Truck.new
    road = Road.new(@c1, @c2) # presenter won't show car
    truck.move_to(road)       #     without placement
    length1 = @presenter.scene.items.length
    @presenter.add(truck)
    truck.draw_item.wont_be_nil
    length2 = @presenter.scene.items.length
    assert_equal(length1+2, length2) # 2 == Truck + text
  end

end
      