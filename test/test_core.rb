require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class TestCore < MiniTest::Unit::TestCase
  require '../src/core'
  def setup
    @core = Core.new
  end

  def teardown
    # Do nothing
  end

  def test_core_init

  end

end
      