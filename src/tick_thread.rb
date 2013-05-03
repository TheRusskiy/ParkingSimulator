class TickThread
  require_relative 'exceptions/needs_set_up_exception'
  require 'thread'
  attr_reader :working
  attr_accessor :paused
  $PAUSE_REFRESH_TIME = 0.1 #seconds
  def initialize
    @working = false
    @ticks_buffer = 0
    @mutex = Mutex.new
    @draw = lambda {}
  end

  def start
    if @delay.nil? or @job.nil?
      raise NeedsSetUpException
    end
    if @working
      raise AlreadyInProgress
    end
    @working=true
    @paused=false
    @time_thread = Thread.new() {get_time_thread.call}
    @job_thread = Thread.new() {get_job_thread.call}
    @time_thread.priority=10
    @job_thread.priority=7
  end

  def stop
    @working = false
  end

  def set_frequency(frequency)
    @delay=1.0/frequency
  end

  def set_job(job)
    @job = job
  end

  def set_draw(draw)
    @draw = draw
  end

  private
  def get_time_thread
    return lambda {
      while @working
        while @working and not @paused
          @ticks_buffer+=1
          sleep(@delay)
        end
        sleep($PAUSE_REFRESH_TIME)
      end
    }
  end

  def get_job_thread
    return lambda {
      ticks_to_process=0
      while @working
        while @working and not @paused
          @mutex.synchronize do
            ticks_to_process+=@ticks_buffer
            @ticks_buffer=0
          end
          while ticks_to_process>0
            ticks_to_process-=1
            @job.call
          end
            @draw.call
          Thread.pass
        end
        sleep($PAUSE_REFRESH_TIME)
      end
    }
  end


end

class AlreadyInProgress < Exception

end