class ParkingLot

  def initialize
    @segments = Array.new
  end

  def set_entrance(road)
    road.parking_lot = self
  end

  def get_all_spots
    spots = Array.new
    @segments.each do |s|
      spots_segm=s.spots
      spots_segm.each do |s2|
        spots << s2
      end
    end
    return spots
  end

  def add_road_segment(parking_road)
    @segments << parking_road
    parking_road.set_parking_lot self
  end

  def assign_spot(car)
    if car.class.name=='Car'
      assign_spot_for_car(car)
    else
      assign_spot_for_truck(car)
    end
  end

  def spot_count
    spots = 0
    @segments.each do |segment|
      spots = spots + segment.spot_count
    end
    return spots
  end

  def has_free_spots?(number_of_spots=1)
    if number_of_spots==1; return free_spot_count!=0; end
    if number_of_spots==2; return free_double_spots?; end
  end

  def free_spot_count
    spots = 0
    @segments.each do |segment|
      spots = spots + segment.free_spot_count
    end
    return spots
  end

  def free_double_spots?
    @segments.each do |segment|
      if segment.free_double_spots?; return true; end;
    end
    return false
  end

  def speed=(value)
    @segments.each do |segment|
      segment.speed=value
    end
  end

  #____P_R_I_V_A_T_E_____#
  private

  def assign_spot_for_car(car)
    @segments.each { |segment|
      free_spot = segment.get_free_spot
      unless free_spot.nil?
        car.assigned_spot=free_spot
        break
      end
    }
  end

  def assign_spot_for_truck(truck)
    @segments.each { |segment|
      free_spots = segment.get_double_free_spot
      unless free_spots.nil?
        truck.assigned_spot=free_spots[0]
        truck.assigned_spot_2=free_spots[1]
        break
      end
    }
  end
end