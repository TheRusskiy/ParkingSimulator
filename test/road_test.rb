require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

class RoadTest < MiniTest::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_fail

    # To change this template use File | Settings | File Templates.
    fail("Not implemented")
  end
  def test_succeed

    # To change this template use File | Settings | File Templates.
    assert_equal(1, 1)
  end
end