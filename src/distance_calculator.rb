class DistanceCalculator
  include Math
  def self.distance_between(c1, c2)
    Math.sqrt((c1.get_x-c2.get_x)**2 + (c1.get_y-c2.get_y)**2)
  end

  def self.slope_between(c1, c2)
    slope = (c2.get_y-c1.get_y)/(c2.get_x-c1.get_x)
    return slope
  end
end