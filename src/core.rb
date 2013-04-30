require '../src/road/road'
require '../src/road/car_generator'
require '../src/road/coordinate'
require '../src/timer_thread'
require '../src/visual/presenter'
require '../src/road/parking_road'
require '../src/road/parking_lot'
require '../src/road/parking_spot'
require '../src/cashier'
class Core
  attr_accessor :controller, :meaningful_tick, :cashier
  attr_reader :uniform_t
  attr_reader :normal_variance
  attr_reader :normal_mean
  attr_reader :exponential_rate
  attr_reader :determined_interval
  def initialize(view)
    @cars = Array.new
    @view=view
    @cashier = Cashier.new
    @tick_divisor=1
    @tick_acc=0
    @normal_variance=1
    @normal_mean=1

    @uniform = CarGenerator.uniform(10)
    @normal = CarGenerator.normal(10, 2)
    @exponential = CarGenerator.exponential(10)
    @determined = CarGenerator.determined(10)
    @generator = @uniform
    @tick_thread = TimerThread.new
    @presenter = Presenter.new(view, 4)

    createCoordinates()
    createRoads()

    usual_speed=1
    lot_speed=0.5
    entrance_exit_speed=0.5
    @road.speed=usual_speed
    @entrance.speed=entrance_exit_speed
    @parking_exit.speed=entrance_exit_speed
    @lot.speed = lot_speed

    @tick_thread.set_frequency(30)
    @tick_thread.job = (lambda{tick})
    @tick_thread.draw = (lambda{@presenter.redraw})
    @presenter.redraw
  end

  def clear_previous()
    if @roads
      @roads.each do |road|
        road.clear
      end
    end
    @cars.each do |car|
      car.placement=nil
    end
    @cars = Array.new
    @presenter.clear
  end

  def createCoordinates
    clear_previous()
    @p_height=40
    @p_length=180
    @to_entrance=30
    @road_start = Coordinate.new(@p_length, @p_height)
    @road_end = Coordinate.new(0, @p_height)
    @road = Road.new(@road_start, @road_end)
    @entrance_start = Coordinate.new(@road_start.x-@to_entrance, @road.coordinate_at(@to_entrance).y)
    @entrance_end = Coordinate.new(@p_length-60, @p_height-10)
    @road2_start = Coordinate.new(@p_length-80, @p_height-40)
    @road3_start = Coordinate.new(@p_length-120, @p_height-40)
    @road3_end = Coordinate.new(@p_length-120, @p_height-10)
    @to_initial_road = 150
    @parking_exit_coord = @road.coordinate_at @to_initial_road
  end

  def createCoordinates_2
    clear_previous()
    @p_height=40
    @p_length=160
    @to_entrance=40
    @road_start = Coordinate.new(@p_length, @p_height)
    @road_end = Coordinate.new(0, @p_height)
    @road = Road.new(@road_start, @road_end)
    @entrance_start = Coordinate.new(@road_start.x-@to_entrance, @road.coordinate_at(@to_entrance).y)
    @entrance_end = Coordinate.new(@p_length-30, @p_height-10)
    @road2_start = Coordinate.new(@p_length-50, @p_height-40)
    @road3_start = Coordinate.new(@p_length-90, @p_height-50)
    @road3_end = Coordinate.new(@p_length-140, @p_height-20)
    @to_initial_road = 150
    @parking_exit_coord = @road.coordinate_at @to_initial_road
  end

  def createRoads
    @entrance = Road.new(@entrance_start, @entrance_end)
    @road.add_parking_entrance(@entrance, @to_entrance)
    @lot = ParkingLot.new
    @lot.set_entrance @entrance
    @road1 = ParkingRoad.new(@entrance_end, @road2_start)
    @road2 = ParkingRoad.new(@road2_start, @road3_start)
    @road3 = ParkingRoad.new(@road3_start, @road3_end)
    @entrance.extension=@road1
    @road1.extension=@road2
    @road2.extension=@road3
    @lot.add_road_segment @road1
    @lot.add_road_segment @road2
    @lot.add_road_segment @road3

    @cashier.spots=@lot.get_all_spots


    @parking_exit = Road.new(@road3_end, @parking_exit_coord)
    @parking_exit.connect_at @road, @to_initial_road
    @road3.extension=@parking_exit

    @presenter.clear
    @presenter.add(@road)
    @presenter.add(@road1)
    @presenter.add(@road2)
    @presenter.add(@road3)
    @presenter.add(@entrance)
    @presenter.add(@parking_exit)
    @presenter.add(@cashier)
    @roads = Array.new
    @roads<<@road
    @roads<<@road1
    @roads<<@road2
    @roads<<@road3
    @roads<<@entrance
    @roads<<@parking_exit
  end

  def tick
    @tick_acc=@tick_acc+1
    if @tick_acc>=@tick_divisor
      @meaningful_tick=true
      @tick_acc=0
    else
      @meaningful_tick=false
    end
    if @meaningful_tick;
      @cashier.turn
      car = @generator.next_car
      @controller.force_draw
    if car and @road.free_space?(car.length+@road.safe_gap)
      @cars<<car
      car.cashier=@cashier
      @cashier.car_inc
      car.wants_to_park(generateParkingTime())
      car.move_to(@road)
      @presenter.add(car)
      @generator.spawned_car=nil
    else
      if car; @generator.spawned_car=car end #preserve trucks in high load
    end
    end
    for each_car in @cars
      each_car.move
      if each_car.placement.nil?; @cars.delete(each_car); end;
    end
    #@view.show
  end

  def start()
    @tick_thread.start
  end

  def generateParkingTime()
    @min_time||=60
    @max_time||=120
    if rand(4)!=0; return 0 end
    @random_time||=Random.new
    @random_time.rand(@max_time-@min_time)+@min_time
  end

  def set_frequency(frequency)
    @tick_thread.set_frequency(frequency)
  end

  def set_car_road_speed(speed)
    @road.speed=speed
    @entrance.speed=speed
    @parking_exit.speed=speed
  end

  def set_parking_speed(speed)
    @lot.speed=speed
  end

  def set_parking_time_scale(scale)
    @cashier.time_scale=scale
  end

  def set_min_parking_time(time)
    @min_time=time
  end

  def set_max_parking_time(time)
    @max_time=time
  end

  def set_safe_gap(gap)
    @roads.each do |road|
      road.safe_gap=gap
    end
  end

  def startStop()
    if @tick_thread.working
      @tick_thread.stop
    else
      @tick_thread.start
    end
  end

  def select_generator(generator)
    case generator
      when "uniform"; @generator=@uniform; @generator_name="uniform"
      when "exponential"; @generator=@exponential; @generator_name="exponential"
      when "normal"; @generator=@normal; @generator_name="normal"
      when "determined"; @generator=@determined; @generator_name="determined"
    end
  end

  def reassign_generator()
    select_generator(@generator_name)
  end

  def slow_simulation_by(times)
    @tick_divisor=times
    @tick_acc=0
  end

  def uniform_t=(value)
    @uniform_t=value
    @uniform=CarGenerator.uniform(value)
  end

  def normal_mean_and_variance(mean, variance)
    @normal_mean=variance
    @normal_variance = mean
    @normal=CarGenerator.normal(mean, variance)
  end

  def exponential_rate=(value)
    @exponential_rate=value
    @exponential=CarGenerator.exponential(value)
  end

  def determined_interval=(value)
    @determined_interval=value
    @determined=CarGenerator.determined(value)
  end
end