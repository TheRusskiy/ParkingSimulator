class DistanceCalculator
  include Math
  def self.distance_between(c1, c2)
    Math.sqrt((c1.x-c2.x)**2 + (c1.y-c2.y)**2)
  end

  def self.angle_between(c1, c2)
    Math.atan2(Float(c2.y-c1.y),Float(c2.x-c1.x)) #* 180 / Math::PI
  end

# @param [Car] car_in_front
# @param [Coordinate||Car] behind
# @param [Numeric] gap
  def self.is_safe_between?(car_in_front, behind, gap)
    #Because of visual implementation, behind car is more important!
    #... so you have to pass it's length in 'Gap'
    if behind.respond_to? :coordinate #it is car, probably
      coord_behind = behind.coordinate
      #behind_length = behind.length
    else
      coord_behind = behind
    end
    if distance_between(car_in_front.coordinate, coord_behind)<gap
      return false
    else
      return true
    end
  end

end