class ParkingSpot
  attr_reader :road
  def initialize(entrance_coordinate, coordinate, owning_road, angle)
    @angle=angle
    @coordinates=Hash.new
    @coordinates[:end]=coordinate
    @coordinates[:start]=entrance_coordinate
    @car = nil
    @assigned_car = nil
    @road = owning_road
  end

  def coordinates(coord_name)
    @coordinates[coord_name]
  end

  def occupied?
    not (@car.nil? and @assigned_car.nil?)
  end

  def assigned_car=(car)
    @assigned_car=car
  end

  def add_car(car)
    @car=car
  end

  def has_car?(car)
    @car.eql? car
  end

end