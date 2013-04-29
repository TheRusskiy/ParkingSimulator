require '../src/core'

class Cashier
  attr_accessor :time_scale, :domestic_price, :import_price
  attr_accessor :truck_price, :night_price, :time, :money
  def initialize
    @time_scale=1
    Car.class_eval do
      attr_accessor :cashier
    end
    @time = Time.now
    @ticks=0
    @money=0
  end

  def night?
    @time.hour<8 || @time.hour>22
  end

  def turn
    @ticks=+1
    @time=+@time_scale
  end
end