require 'minitest/autorun'
require 'minitest/reporters'
require 'Qt'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class TestCore < MiniTest::Unit::TestCase
  require '../src/core'
  require '../src/visual/parkingview'
  @app = Qt::Application.new(ARGV)
  def setup
    @core = Core.new(Qt::GraphicsScene.new)
    @core.wont_be_nil
  end

  def teardown
    # Do nothing
  end

  def test_can_tick
    @core.tick
  end

end
      