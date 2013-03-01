require 'minitest/autorun'
require "minitest/reporters"
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class StateTest < MiniTest::Unit::TestCase
  require '../src/state'

  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  def test_initialization
    state = State.new
  end
end
