require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class TestCarGenerator < MiniTest::Unit::TestCase
  require '../src/road/car_generator'
  def setup
    seed=1
    @uniform = CarGenerator.uniform(100, seed)
  end

  def teardown
    # Do nothing
  end

  def test_uniform_get_random
    acc=0
    for i in 1..10000
      if @uniform.next_car;
        acc=acc+1
      end
    end
    assert_in_delta(acc, 100, 20);
  end

  def test_spawns_car
    car = @uniform.next_car
    while car.nil?
      car = @uniform.next_car
    end
    assert_kind_of(Car, car)
  end

end
      