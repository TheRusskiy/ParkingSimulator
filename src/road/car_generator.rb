class CarGenerator
  def self.uniform(delay_between_cars, seed=-1)
    return UniformGenerator.new(delay_between_cars, seed)
  end
end
private
class UniformGenerator
  @delay
  def initialize(delay_between_cars, seed)
    @random = seed==-1 ? Random.new : Random.new(seed)
    @car_type = seed==-1 ? Random.new : Random.new(seed)
    @delay = delay_between_cars;
  end

  def next_car
    if @random.rand(@delay) == 0
      return create_car
    else
      return nil
    end
  end

  def create_car()
    if @car_type.rand(2) == 0
      return Truck.new
    else
      return Car.new
    end
  end

end