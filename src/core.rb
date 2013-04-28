require '../src/road/road'
require '../src/road/car_generator'
require '../src/road/coordinate'
require '../src/timer_thread'
require '../src/visual/presenter'
require '../src/road/parking_road'
require '../src/road/parking_lot'
require '../src/road/parking_spot'
class Core
  def initialize(view)
    @cars = Array.new
    @view=view


    ##_________________________
    #@road_start = Coordinate.new(80, 100)
    #@road_end = Coordinate.new(0, 100)
    #@road = Road.new(@road_start, @road_end)
    #to_entrance=10
    #@entrance_start = Coordinate.new(@road_start.x-to_entrance, @road.coordinate_at(to_entrance).y)
    #@entrance_end = Coordinate.new(40, 90)
    #@entrance = Road.new(@entrance_start, @entrance_end)
    #@road.add_parking_entrance(@entrance, to_entrance)
    #
    #@lot = ParkingLot.new
    #@lot.set_entrance @entrance
    #
    #@road2_start = Coordinate.new(100, 80)
    #@road3_start = Coordinate.new(50, 80)
    #@road3_end = Coordinate.new(20, 90)
    #@road1 = Road.new(@entrance_end, @road3_start)
    ##@road2 = ParkingRoad.new(@road2_start, @road3_start)
    #@road3 = ParkingRoad.new(@road3_start, @road3_end)
    #@entrance.extension=@road1
    #@road1.extension=@road3
    ##@road2.extension=@road3
    ##@lot.add_road_segment @road1
    ##@lot.add_road_segment @road2
    #@lot.add_road_segment @road3
    #
    #to_initial_road = 70
    #@parking_exit_coord = @road.coordinate_at to_initial_road
    #@parking_exit = Road.new(@road3_end, @parking_exit_coord)
    #@parking_exit.connect_at @road, to_initial_road
    #@road3.extension=@parking_exit


    @road_start = Coordinate.new(180, 100)
    @road_end = Coordinate.new(0, 100)
    @road = Road.new(@road_start, @road_end)

    to_entrance=30
    @entrance_start = Coordinate.new(@road_start.x-to_entrance, @road.coordinate_at(to_entrance).y)
    @entrance_end = Coordinate.new(120, 90)
    @entrance = Road.new(@entrance_start, @entrance_end)
    @road.add_parking_entrance(@entrance, to_entrance)

    @lot = ParkingLot.new
    @lot.set_entrance @entrance

    @road2_start = Coordinate.new(100, 40)
    @road3_start = Coordinate.new(60, 40)
    @road3_end = Coordinate.new(50, 90)
    @road1 = ParkingRoad.new(@entrance_end, @road2_start)
    @road2 = ParkingRoad.new(@road2_start, @road3_start)
    @road3 = ParkingRoad.new(@road3_start, @road3_end)
    @entrance.extension=@road1
    @road1.extension=@road2
    @road2.extension=@road3
    @lot.add_road_segment @road1
    @lot.add_road_segment @road2
    @lot.add_road_segment @road3

    to_initial_road = 150
    @parking_exit_coord = @road.coordinate_at to_initial_road
    @parking_exit = Road.new(@road3_end, @parking_exit_coord)
    @parking_exit.connect_at @road, to_initial_road
    @road3.extension=@parking_exit

    @generator = CarGenerator.uniform(1)
    @tick_thread = TimerThread.new
    @presenter = Presenter.new(view, 4)

    @presenter.add(@road)
    @presenter.add(@road1)
    @presenter.add(@road2)
    @presenter.add(@road3)
    @presenter.add(@entrance)
    @presenter.add(@parking_exit)

    @tick_thread.set_frequency(100)
    @tick_thread.job = (lambda{tick})
    @tick_thread.draw = (lambda{@presenter.redraw})
    @presenter.redraw
  end

  def tick
    car = @generator.next_car
    if car and @road.free_space?(car.length+@road.safe_gap)
      @cars<<car
      if rand(2)==0; car.wants_to_park 60 end
      car.move_to(@road)
      @presenter.add(car)
      @generator.spawned_car=nil
    else
      if car; @generator.spawned_car=car end #preserve trucks in high load
    end
    for each_car in @cars
      each_car.move_by(0.5)
      if each_car.placement.nil?; @cars.delete(each_car); end;
    end
    @view.show
  end

  def start()
    @tick_thread.start
  end
end