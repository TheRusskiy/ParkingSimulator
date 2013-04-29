class ParkingController
  attr_accessor :simulation_speed
  attr_accessor :car_road_speed
  attr_accessor :car_parking_speed
  attr_accessor :discretization
  attr_accessor :parking_time_scale
  attr_accessor :min_parking_time
  attr_accessor :max_parking_time
  attr_accessor :safe_gap
  alias :dis :discretization
  def initialize(core, window)
    @core = core
    @core.controller=self
    @view = window
    @view.controller=self
  #  TODO fetch default values from view
  end
  def refresh_model
    @discretization=Float(@discretization)
    @core.set_frequency @simulation_speed*@discretization
    @core.set_car_road_speed @car_road_speed/@discretization
    @core.set_parking_speed @car_parking_speed/@discretization
    @core.set_parking_time_scale @parking_time_scale/@discretization
    @core.set_min_parking_time @min_parking_time*60 #minutes to seconds
    @core.set_max_parking_time (@min_parking_time+@max_parking_time)*60 # max is shift from min
    @core.set_safe_gap @safe_gap
  end
end