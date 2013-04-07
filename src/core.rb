require '../src/road/road'
require '../src/road/car_generator'
require '../src/road/coordinate'
require '../src/tick_thread'
require '../src/visual/presenter'
class Core

  def initialize(view)
    @i=0
    @road_start = Coordinate.new(0, 0)
    @road_end = Coordinate.new(100, 100)
    @road = Road.new(@road_start, @road_end)
    @generator = CarGenerator.uniform(1)
    @tick_thread = TickThread.new
    @presenter = Presenter.new(view)
    @tick_thread.set_frequency(30)
    @tick_thread.set_job(lambda{tick})
    @tick_thread.set_draw(lambda{@presenter.redraw})
  end

  def tick
    @i=@i+1
    puts @i
    car = @generator.next_car
    if car
      puts "car"
      @road.add_car(car)
      @presenter.add(car)
    end
    for car in @road.cars
      car.move_by(2)
    end
  end

  def start()
    @tick_thread.start
  end
end