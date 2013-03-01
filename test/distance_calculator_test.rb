require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class DistanceCalculatorTest < MiniTest::Unit::TestCase
  require '../src/distance_calculator'
  include Math
  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  def test_create
    d = DistanceCalculator.new
  end

  def test_distance_between
    c1=Coordinate.new(0, 0)
    c2=Coordinate.new(3, 4)
    assert_in_delta(DistanceCalculator.distance_between(c1, c2), 5, 0.1)
  end

  def test_slope_between()
    c1=Coordinate.new(0, 0)
    c2=Coordinate.new(1, 1)
    assert_in_delta(DistanceCalculator.slope_between(c1, c2), 1, 0.01)
    c1=Coordinate.new(0, 0)
    c2=Coordinate.new(1, 0)
    assert_in_delta(DistanceCalculator.slope_between(c1, c2), 0, 0.01)
  end

end
      