require '../src/core'

class Cashier
  attr_accessor :time_scale
  def initialize
    @time_scale=1
    Car.class_eval do
      attr_accessor :cashier
    end
  end
end