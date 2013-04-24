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
    @road_start = Coordinate.new(160, 100)
    @road_end = Coordinate.new(0, 100)
    @road = Road.new(@road_start, @road_end)

    #@road2_start = Coordinate.new(100, 0)
    #@road2_end = Coordinate.new(100, 100)
    #@road2 = Road.new(@road2_start, @road2_end)
    #@road.extension=@road2

    to_entrance=40
    @entrance_start = Coordinate.new(@road_start.x-to_entrance, @road.coordinate_at(to_entrance).y)
    @entrance_end = Coordinate.new(70, 90)
    @entrance = Road.new(@entrance_start, @entrance_end)
    @road.add_parking_entrance(@entrance, to_entrance)

    @lot = ParkingLot.new
    @lot.set_entrance @entrance

    @road2_start = Coordinate.new(60, 20)
    @road3_start = Coordinate.new(20, 20)
    @road3_end = Coordinate.new(20, 90)
    @road1 = ParkingRoad.new(@entrance_end, @road2_start)
    @road2 = ParkingRoad.new(@road2_start, @road3_start)
    @road3 = ParkingRoad.new(@road3_start, @road3_end)
    @entrance.extension=@road1
    @road1.extension=@road2
    @road2.extension=@road3
    @lot.add_road_segment @road1
    @lot.add_road_segment @road2
    @lot.add_road_segment @road3

    to_initial_road = 100
    @parking_exit_coord = @road.coordinate_at to_initial_road
    @parking_exit = Road.new(@road3_end, @parking_exit_coord)
    @parking_exit.connect_at @road, to_initial_road
    @road3.extension=@parking_exit

    @generator = CarGenerator.uniform(20)
    @tick_thread = TimerThread.new
    @presenter = Presenter.new(view, 4)

    @presenter.add(@road)
    @presenter.add(@road1)
    @presenter.add(@road2)
    @presenter.add(@road3)
    @presenter.add(@entrance)
    @presenter.add(@parking_exit)

    @tick_thread.set_frequency(60)
    @tick_thread.job = (lambda{tick})
    @tick_thread.draw = (lambda{@presenter.redraw})
    @presenter.redraw
  end

  def tick
    car = @generator.next_car
    if car and @road.free_space?
      @cars<<car
      if rand(2)==0; car.wants_to_park 10 end
      puts "car"
      car.move_to(@road)
      @presenter.add(car)
    end
    for car in @cars
      car.move_by(1)
      if car.placement.nil?; @cars.delete(car); end;
    end
    @view.show
  end

  def start()
    @tick_thread.start
  end
end