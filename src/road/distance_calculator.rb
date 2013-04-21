class DistanceCalculator
  include Math
  def self.distance_between(c1, c2)
    Math.sqrt((c1.x-c2.x)**2 + (c1.y-c2.y)**2)
  end

  def self.angle_between(c1, c2)
    Math.atan2(Float(c2.y-c1.y),Float(c2.x-c1.x)) #* 180 / Math::PI
  end

  def self.is_safe_between?(car_in_front, behind, gap)
    if behind.respond_to? :coordinate
      coord_behind = behind.coordinate
    else
      coord_behind = behind
    end
    if distance_between(car_in_front.coordinate, coord_behind)<car_in_front.length+gap
      return false
    else
      return true
    end
  end

end