require 'minitest/autorun'
require 'minitest/reporters'
require 'Qt'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class TestCore < MiniTest::Unit::TestCase
  require '../src/core'
  def setup
    @core = Core.new(ParkingView.new)
    @core.wont_be_nil
  end

  def teardown
    # Do nothing
  end

  def test_can_tick
    @core.tick
  end

end
      