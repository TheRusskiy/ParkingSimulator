require_relative 'core'
require 'time'
require 'date'

class Cashier
  attr_accessor :time_scale, :domestic_price, :imported_price, :spots
  attr_accessor :truck_price, :night_price, :time, :money, :ticks, :car_counter
  attr_accessor :billing_enabled
  def initialize
    @time_scale=1
    Car.class_eval do
      attr_accessor :cashier
    end
    @time_past_seconds=0
    @time = Time.new(Time.now - Time.now)
    @ticks=0
    @money=0
    @car_counter=0
    @billing_enabled=true
  end

  def night?
    @time.hour<8 || @time.hour>22
  end

  def time_past
    @time
  end

  def turn
    @ticks=@ticks+1
    @time=@time+@time_scale
  end

  def car_inc
    @car_counter=@car_counter+1
  end

  def bill(car, turns)
    return unless @billing_enabled
    type=car.getModel
    money=0
    case type
      when "domestic"; money=@domestic_price
      when "truck"; money=@truck_price
      when "imported"; money=@imported_price
    end
    if night?; money=money*(100-@night_price)/100 end
    money=turns*money/60/60;
    @money=@money+money
  end
end