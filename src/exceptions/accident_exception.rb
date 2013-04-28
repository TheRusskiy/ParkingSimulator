class AccidentException < Exception
  def initialize(car1, car2)
    @car2 = car2
    @car1 = car1
  end
  def message
    super
  end
  def to_s
    super+':'+@car1.coordinate.to_s+'-'+@car1.placement.to_s+', '+@car2.coordinate.to_s+'-'+@car2.placement.to_s
  end


end