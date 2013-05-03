class TimerThread
  require_relative 'exceptions/needs_set_up_exception'
  require 'thread'
  require 'Qt4'
  attr_reader :working
  attr_accessor :paused
  attr_writer :job, :draw
  $PAUSE_REFRESH_TIME = 0.0 #seconds
  $REDRAW_RATE = 1000.0 /
                    25.0 #times in a second
  def initialize
    @milli_acc = 0
    @working = false
    @draw = lambda {}
    @timer = QTimer.new(self)
    @last_time = Time.now
  end

  def start
    if @delay.nil? or @job.nil?
      raise NeedsSetUpException
    end
    if @working
      raise AlreadyInProgress
    end
    @working=true
    #@timer_id = @timer.startTimer(@delay)
    set_frequency(1000.0/@delay)
  end

  def timerEvent(event)
    return unless @working
    @job.call
    @milli_acc = @milli_acc + (Time.now - @last_time)*1000
    if @milli_acc > $REDRAW_RATE
       @milli_acc = 0
       @draw.call
    end
    #puts (Time.now-@last_time).to_s
    @last_time = Time.now
    Thread.pass
  end

  def stop
    @working = false
  end

  def set_frequency(frequency)
    @delay=1000.0/frequency
    if @timer_id;
      @timer.killTimer(@timer_id)
    end;
    @timer=QTimer.new(self)
    @timer_id=@timer.startTimer(@delay)
  end

end

class AlreadyInProgress < Exception

end

class QTimer < Qt::Object
  def initialize(to_invoke)
    super(nil)
    @to_invoke = to_invoke
  end

  def timerEvent(event)
    @to_invoke.timerEvent(event)
  end
end