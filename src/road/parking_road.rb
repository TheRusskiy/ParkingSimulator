class ParkingRoad < Road
  require_relative 'parking_spot'
  $SPOT_LENGTH = 6
  attr_reader :spots
  def initialize(start_coord, end_coord)
    super(start_coord, end_coord)
    @spots = Array.new
    create_spots
  end

  def spot_count
    @spots.length
  end

  def free_spot_count
    free=0
    @spots.each do |spot|
      free=free+1 unless spot.occupied?
    end
    free
  end

  def move_car_by(car, by_space)
    super car, by_space
    if car.wants_to_park? and car.assigned_spot.road==self
       start_car = DistanceCalculator.distance_between(@coordinates[:start], car.coordinate)
       start_spot = DistanceCalculator.distance_between(@coordinates[:start], car.assigned_spot.coordinates(:start))
      if start_car>=start_spot
        car.move_to car.assigned_spot
        @cars.delete car
      end
    end
  end


  def set_parking_lot(lot)
    @parking_lot = lot
  end

  def get_free_spot
    @spots.each do |spot|
      return spot unless spot.occupied?
    end
    return nil
  end

  #def get_state(car)
  #  state = super(car)
  #  if state.target_spot.nil?; state.target_spot=find_spot(car)
  #  state.distance_to_free_spot=closest_spot_to(car.coordinate)
  #end
  #
  #def closest_spot_to(coord)
  #  closest = nil
  #  for spot in @spots
  #    if closest.nil?; closest=spot end
  #
  #  end
  #end

  #____P_R_I_V_A_T_E_____#
  private
  def create_spots
    fake=FakeCar.new(@coordinates[:start])
    dx = $SPOT_LENGTH*@cosine
    dy = $SPOT_LENGTH*@sinus
    move_car($SPOT_LENGTH, fake) #skip first 6 meters
    while DistanceCalculator.distance_between(fake.coordinate, @coordinates[:end])>$SPOT_LENGTH
      c1 = Coordinate.new(fake.coordinate.x-dy/2, fake.coordinate.y+dx/2)
      p1 = ParkingSpot.new(fake.coordinate, c1, self, @angle, true)
      c2 = Coordinate.new(fake.coordinate.x+dy/2, fake.coordinate.y-dx/2)
      p2 = ParkingSpot.new(fake.coordinate, c2, self, @angle, false)
      move_car($SPOT_LENGTH, fake)
      @spots<<p1
      @spots<<p2
    end
  end

  class FakeCar
    attr_accessor :coordinate
    def initialize(coordinate)
      @coordinate=coordinate
    end
    def stopped?
      false
    end
  end

end