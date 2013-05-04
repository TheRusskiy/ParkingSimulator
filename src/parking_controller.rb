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
  attr_accessor :domestic
  attr_accessor :imported
  attr_accessor :truck
  attr_accessor :night, :core
  def initialize(core, window)
    @core = core
    @core.controller=self
    @view = window
    @view.controller=self
    @cashier=@core.cashier
    @view.applyPrices
    @view.applyControls
    @view.setRandomProperties()
    @view.display_information(@cashier)
    @view.selectUniform()
    @view.refresh_view_scale
    @view.setParkingPercent
  end

  def refresh_model
    @discretization=Float(@discretization)
    @core.set_frequency @simulation_speed*@discretization
    @core.set_car_road_speed @car_road_speed/@discretization
    @core.set_parking_speed @car_parking_speed/@discretization
    @core.set_parking_time_scale @parking_time_scale
    @core.set_min_parking_time @min_parking_time*60 #minutes to seconds
    @core.set_max_parking_time (@min_parking_time+@max_parking_time)*60 # max is shift from min
    @core.set_safe_gap @safe_gap
    @core.slow_simulation_by @discretization
  end

  def refresh_prices
    @cashier.domestic_price=@domestic
    @cashier.imported_price=@imported
    @cashier.truck_price=@truck
    @cashier.night_price=@night
  end

  def refresh_random_params
    @core.uniform_t= @uniform_t
    @core.normal_mean_and_variance(@normal_mean, @normal_variance)
    @core.exponential_rate = @exponential_rate
    @core.determined_interval = @determined_interval
    @core.reassign_generator
  end

  def startStop()
    @core.startStop()
  end

  def force_draw()
    @view.display_information(@cashier)
  end

  def select_generator(name)
    @core.select_generator(name)
  end

  def change_scale(value)
    @core.change_scale(value)
  end

  def parking_chance=(value)
    @core.chance_to_park=value
  end

  def truck_percent=(value)
    @core.truck_percent=value
  end

end