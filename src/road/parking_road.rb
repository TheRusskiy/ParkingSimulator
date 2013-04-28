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

  def free_double_spots?
    return (not get_double_free_spot.nil?)
  end

  def get_double_free_spot
    assign_left_right_arrays
    result = get_double_free_spots_for_array @lefts
    result||= get_double_free_spots_for_array @rights
    return result
  end

  #____P_R_I_V_A_T_E_____#
  private
  def create_spots
    fake=FakeCar.new(@coordinates[:start])
    dx = $SPOT_LENGTH*@cosine
    dy = $SPOT_LENGTH*@sinus
    move_car($SPOT_LENGTH, fake) #skip first 6 meters
    right_counter = 0
    left_counter = 0
    while DistanceCalculator.distance_between(fake.coordinate, @coordinates[:end])>$SPOT_LENGTH
      c1 = Coordinate.new(fake.coordinate.x-dy/2+dx/4, fake.coordinate.y+dx/2+dy/4)
      p1 = ParkingSpot.new(fake.coordinate, c1, self, @angle, true)
      p1.number=left_counter
      c2 = Coordinate.new(fake.coordinate.x+dy/2+dx/4, fake.coordinate.y-dx/2+dy/4)
      p2 = ParkingSpot.new(fake.coordinate, c2, self, @angle, false)
      p2.number=right_counter
      move_car($SPOT_LENGTH, fake)
      @spots<<p1
      @spots<<p2
      right_counter = right_counter + 1
      left_counter = left_counter + 1
    end
  end

  def assign_left_right_arrays
    @lefts = Array.new
    @rights = Array.new
    @spots.each do |spot|
      @lefts << spot unless (spot.occupied? or not spot.is_left)
      @rights << spot unless (spot.occupied? or spot.is_left)
    end
  end

  def get_double_free_spots_for_array(spots)
    first=nil
    results = Array.new
    spots.each do |spot|
      if first.nil?
        first=spot
        next
      end
      if spot.number==first.number+1
        results[0]=first
        results[1]=spot
      else
        first=spot
      end
    end
    if results.length==2
      return results
    else
      return nil
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