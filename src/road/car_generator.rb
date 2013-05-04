class CarGenerator
  require 'rubystats'
  def self.uniform(delay_between_cars, seed=-1)
    return UniformGenerator.new(delay_between_cars, seed)
  end
  def self.normal(mean, sigma)
    return NormalGenerator.new(mean, sigma)
  end
  def self.exponential(rate)
    return ExponentialGenerator.new(rate)
  end
  def self.determined(interval)
    return DeterminedGenerator.new(interval)
  end
end
private
module AbstractRandomGenerator
  attr_writer :spawned_car
  attr_accessor :truck_probability
  @delay
  def spawns?
    throw 'abstract!'
  end

  def next_car
    @spawned_car||=create_car
    if spawns?
      return @spawned_car
    else
      return nil
    end
  end

  def create_car()
    @truck_probability||=25
    if rand(100) < @truck_probability
      return Truck.new
    else
      return Car.new
    end
  end
end

class UniformGenerator
  include AbstractRandomGenerator
  @delay
  def initialize(delay_between_cars, seed)
    @random = seed==-1 ? Random.new : Random.new(seed)
    @delay = delay_between_cars;
  end

  def spawns?
    @random.rand(@delay) == 0
  end
end

class NormalGenerator
  include AbstractRandomGenerator
  def initialize(mean, sigma)
    @normal = Rubystats::NormalDistribution.new(mean, sigma)
    @memory=0
  end

  def spawns?
    @memory=@memory+@normal.rng
    if @memory>=100
      @memory=@memory-100
      return true
    else
      return false
    end
  end
end

class ExponentialGenerator
  include AbstractRandomGenerator
  def initialize(rate)
    @exp = Rubystats::ExponentialDistribution.new(rate)
    @memory=0
  end

  def spawns?
    @memory=@memory+@exp.rng
    if @memory>=1
      @memory=@memory-1
      return true
    else
      return false
    end
  end
end

class DeterminedGenerator
  include AbstractRandomGenerator
  def initialize(interval)
    @memory=0
    @interval=interval
  end

  def spawns?
    @memory=@memory+1
    if @memory>=@interval
      @memory=0
      return true
    else
      return false
    end
  end
end

