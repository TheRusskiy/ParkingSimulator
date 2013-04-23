require '../src/road/road'
require '../src/road/car_generator'
require '../src/road/coordinate'
require '../src/timer_thread'
require '../src/visual/presenter'
class Core
  def initialize(view)
    @cars = Array.new
    @view=view
    @road_start = Coordinate.new(0, 0)
    @road_end = Coordinate.new(100, 0)
    @road = Road.new(@road_start, @road_end)

    @road2_start = Coordinate.new(100, 0)
    @road2_end = Coordinate.new(100, 100)
    @road2 = Road.new(@road2_start, @road2_end)
    @road.extension=@road2

    @entrance_start = Coordinate.new(40, 0)
    @entrance_end = Coordinate.new(80, 100)
    @entrance = Road.new(@entrance_start, @entrance_end)
    @road.add_parking_entrance(@entrance, 40)

    @generator = CarGenerator.uniform(20)
    @tick_thread = TimerThread.new
    @presenter = Presenter.new(view, 4)

    @presenter.add(@road)
    @presenter.add(@road2)
    @presenter.add(@entrance)

    @tick_thread.set_frequency(30)
    @tick_thread.job = (lambda{tick})
    @tick_thread.draw = (lambda{@presenter.redraw})
  end

  def tick
    car = @generator.next_car
    if car and @road.free_space?
      @cars<<car
      if rand(2)==0; car.wants_to_park 1 end
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