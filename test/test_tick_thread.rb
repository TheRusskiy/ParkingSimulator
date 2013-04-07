require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

class TestTickThread < MiniTest::Unit::TestCase
  require '../src/tick_thread'
  def setup
    @tt = TickThread.new
  end

  def teardown
    @tt.stop
  end

  def test_can_be_started_and_stoped
    @tt.set_job(lambda {})
    @tt.set_frequency(1)
    @tt.working.must_equal false
    @tt.start
    @tt.working.must_equal true
    @tt.stop
    @tt.working.must_equal false
  end

  def test_cant_be_started_twice
    @tt.set_job(lambda {})
    @tt.set_frequency(1)
    @tt.start
    assert_raises(AlreadyInProgress){@tt.start}
  end

  def test_can_execute_your_function_n_times
    $PAUSE_REFRESH_TIME=0
    @tt.set_frequency(100)
    counter = 0
    @tt.set_job(lambda{
      counter+=1
    })
    @tt.start
    sleep(0.1)
    @tt.stop
    counter.must_be_close_to 10, 1
  end

  def test_can_be_paused_and_resumed
    $PAUSE_REFRESH_TIME=0
    @tt.set_frequency(100)
    counter = 0
    @tt.set_job(lambda{
      counter+=1
    })
    @tt.start
    sleep(0.05)
    @tt.paused=true
    temp_counter=counter
    sleep(0.05)
    temp_counter.must_equal counter
    @tt.paused=false
    sleep(0.05)
    @tt.stop
    counter.must_be_close_to 10, 2
  end

  def test_raises_if_no_frequency_or_job
    assert_raises(NeedsSetUp) {@tt.start.must_raise}
  end


end
      