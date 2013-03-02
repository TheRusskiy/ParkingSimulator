class TickThread
  require '../src/needs_set_up'
  attr_reader :working
  attr_accessor :paused
  $PAUSE_REFRESH_TIME = 0.1 #seconds
  def initialize
    @working = false
    @ticks_buffer = 0
  end

  def start
    if @delay.nil? or @job.nil?
      raise NeedsSetUp
    end
    if @working
      raise AlreadyInProgress
    end
    @working=true
    @paused=false
    @time_thread = Thread.new() {get_time_thread.call}
    @internal_thread = Thread.new() {get_ticker.call}
    @internal_thread.priority=10
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

  private
  def get_ticker
    return lambda {
      while @working
        while @working and not @paused
          t1=Time.now
          @job.call
          t2=Time.now
          threshold=@delay-(t2-t1)
          if threshold > 0 #draw if time's left
            # draw
            # todo: threshold > draw_time (empirical) ?
            threshold=@delay-(Time.now-t2)
            if threshold > 0 #sleep if time's left
              sleep(threshold)
            else
              # todo: if threshold is negative low delay for the next time(only one time)
              puts "WARNING!!! Can't process that fast, delay=#{@delay}"
            end
          else
            puts "WARNING!!! Frame had to be skipped, delay=#{@delay}"
          end
        end
        sleep($PAUSE_REFRESH_TIME)
      end
    }
  end



end


class AlreadyInProgress < Exception

end