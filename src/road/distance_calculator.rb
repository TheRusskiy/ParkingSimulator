class DistanceCalculator
  include Math
  $SAFE_CAR_DISTANCE = 5
  def self.distance_between(c1, c2)
    Math.sqrt((c1.get_x-c2.get_x)**2 + (c1.get_y-c2.get_y)**2)
  end

  def self.angle_between(c1, c2)
    Math.atan2(Float(c2.get_y-c1.get_y),Float(c2.get_x-c1.get_x)) #* 180 / Math::PI
  end

  def self.is_safe_between?(coord1, coord2)
    if distance_between(coord1, coord2)<$SAFE_CAR_DISTANCE
      return false
    else
      return true
    end
  end

end