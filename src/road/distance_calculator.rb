class DistanceCalculator
  include Math
  $SAFE_CAR_DISTANCE = 5
  def self.distance_between(c1, c2)
    Math.sqrt((c1.get_x-c2.get_x)**2 + (c1.get_y-c2.get_y)**2)
  end

  def self.slope_between(c1, c2)
    slope = Float(c2.get_y-c1.get_y)/(c2.get_x-c1.get_x)
    return slope
  end

  def self.angle_between(c1, c2)
    return Math.atan(slope_between(c1, c2)) * 180 / Math::PI
  end

  def self.is_safe_between?(car1, car2)
    if distance_between(car1.coordinate, car2.coordinate)<$SAFE_CAR_DISTANCE
      return false
    else
      return true
    end
  end

end