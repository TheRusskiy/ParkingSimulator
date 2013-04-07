require '../src/road/road'
require '../src/road/car_generator'
require '../src/road/coordinate'
require '../src/timer_thread'
require '../src/visual/presenter'
class Core
  @view
  def initialize(view)
    @view=view
    @road_start = Coordinate.new(0, 0)
    @road_end = Coordinate.new(100, 0)
    @road = Road.new(@road_start, @road_end)
    @generator = CarGenerator.uniform(20)
    @tick_thread = TimerThread.new
    @presenter = Presenter.new(view, 2)
    @tick_thread.set_frequency(30)
    @tick_thread.job = (lambda{tick})
    @tick_thread.draw = (lambda{@presenter.redraw})
  end

  def tick
    car = @generator.next_car
    if car and @road.free_space?
      puts "car"
      car.move_to(@road)
      @presenter.add(car)
    end
    for car in @road.cars
      car.move_by(2)
    end
    @view.show
  end

  def start()
    @tick_thread.start
  end
end