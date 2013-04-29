class ParkingController
  attr_accessor :simulation_speed
  attr_accessor :car_road_speed
  attr_accessor :car_parking_speed
  attr_accessor :discretization
  attr_accessor :parking_time_scale
  attr_accessor :min_parking_time
  attr_accessor :max_parking_time
  attr_accessor :safe_gap
  attr_accessor :uniform_t
  attr_accessor :normal_variance
  attr_accessor :normal_mean
  attr_accessor :exponential_rate
  attr_accessor :determined_interval
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
    @core.slow_simulation_by @discretization
  end

  def refresh_random_params
    @core.uniform_t= @uniform_t
    @core.normal_mean= @normal_mean
    @core.normal_variance= @normal_variance
    @core.exponential_rate = @exponential_rate
    @core.determined_interval = @determined_interval
  end

  def startStop()
    @core.startStop()
  end

  def selectUniform()
    @core.selectUniform
  end

  def selectExponential()
    @core.selectExponential
  end

  def selectNormal()
    @core.selectNormal
  end

  def selectDetermined()
    @core.selectDetermined()
  end
end