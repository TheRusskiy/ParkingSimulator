class ParkingLot

  def initialize
    @segments = Array.new
  end

  def set_entrance(road)
    road.parking_lot = self
  end

  def add_road_segment(parking_road)
    @segments << parking_road
    parking_road.set_parking_lot self
  end

  def assign_spot(car)
    @segments.each { |segment|
      free_spot = segment.get_free_spot
      unless free_spot.nil?
        car.assigned_spot=free_spot
        break
      end
    }
  end

  def spot_count
    spots = 0
    @segments.each do |segment|
      spots = spots + segment.spot_count
    end
    return spots
  end

  def has_free_spots?
    free_spot_count!=0
  end

  def free_spot_count
    spots = 0
    @segments.each do |segment|
      spots = spots + segment.free_spot_count
    end
    return spots
  end
end