require 'minitest/autorun'
require 'minitest/reporters'
require 'Qt'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class PresenterTest < MiniTest::Unit::TestCase
  require '../src/visual/presenter'
  require '../src/visual/parkingview'
  require '../src/road/road'

  @app = Qt::Application.new(ARGV)

  def setup
    @presenter = Presenter.new(ParkingView.new(Qt::GraphicsScene.new))
    @road = Road.new
    @car = Car.new
    @car.move_to @road
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
    assert_equal(length1+1, length2)
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

end
      