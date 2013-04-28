class Presenter
  require_relative 'GraphicCar'
  require_relative 'GraphicRoad'
  require_relative 'GraphicParkingSpot'
  require_relative '../road/car'
  require_relative '../road/road'
  require_relative '../road/parking_road'
  require_relative '../road/parking_spot'
  require 'Qt'
  attr_reader :scene
  @scale
  @scene
  def scale=(value)
    @scale=value
  end
  def scale
    @scale
  end
  def initialize(view, scale = 5)
    @scene = view.scene
    @scale = scale
    @objects = Array.new
    add_draw_item_to_classes()
    #Car.class_eval do
    #
    #end
    #  #def add_attrs(attrs)
    #  #  attrs.each do |var, value|
    #  #    class_eval { attr_accessor var }
    #  #    instance_variable_set "@#{var}", value
    #  #  end
    #  #end
    #end

  end

  def add_draw_item_to_classes
    Car.class_eval do
      attr_accessor :draw_item
    end
    Road.class_eval do
      attr_accessor :draw_item
    end
    ParkingRoad.class_eval do
      attr_accessor :draw_item
    end
    ParkingSpot.class_eval do
      attr_accessor :draw_item
    end
  end

  def add(object)
    @objects << object
    case object.class.name
      when 'Road'
        object.draw_item = GraphicRoad.new(object.coordinates(:start).x,
                                           object.coordinates(:start).y,
                                           object.coordinates(:end).x,
                                           object.coordinates(:end).y)
        object.draw_item.setScale(@scale)
        @scene.addItem(object.draw_item)
      when 'Car'
        object.draw_item = GraphicCar.new
        object.draw_item.setScale(@scale)
        @scene.addItem(object.draw_item)

        object.draw_item.car=object

        draw_car object
      when 'Truck'
        object.draw_item = GraphicTruck.new
        object.draw_item.setScale(@scale)
        @scene.addItem(object.draw_item)

        object.draw_item.car=object


        draw_car object
      when 'ParkingRoad'
        object.draw_item = GraphicRoad.new(object.coordinates(:start).x,
                                           object.coordinates(:start).y,
                                           object.coordinates(:end).x,
                                           object.coordinates(:end).y)
        object.draw_item.setScale(@scale)
        @scene.addItem(object.draw_item)
        spots = object.spots
        spots.each { |spot|
          add spot
        }
      when 'ParkingSpot'
        object.draw_item = GraphicParkingSpot.new(object.coordinate, object.is_left, object.angle, $SPOT_LENGTH)
        object.draw_item.setScale(@scale)
        @scene.addItem(object.draw_item)
    end
  end


  def redraw
    for object in @objects
      case object.class.name
        when 'Road'
          draw_road(object)
        when 'Car'
          draw_car(object)
        when 'Truck'
          draw_car(object)
        when 'ParkingRoad'
          draw_road(object)
        when 'ParkingSpot'
          draw_spot(object)
      end
    end
  end

  def draw_car(car)
    if car.placement.nil?
      @scene.removeItem(car.draw_item)
      @objects.delete(car)
      return
    end
    cosin=Math.cos car.placement.angle
    sinus=Math.sin car.placement.angle
    width = car.class.name=='Truck' ? 3 : 2
    x_shift = @scale*sinus*width/2
    y_shift = -@scale*cosin*width/2
    car.draw_item.setPos(x(car.coordinate)+x_shift, y(car.coordinate)+y_shift)
    car.draw_item.setRotation(car.state.rotation/Math::PI*180.0)
    car.draw_item.setScale(@scale)
  end

  def draw_spot(spot)
    spot.draw_item.setPos(x(spot.coordinate), y(spot.coordinate))
    spot.draw_item.assigned=spot.assigned?
    spot.draw_item.setScale(@scale)
  end

  def draw_road(road)
    road.draw_item.setScale(@scale)
  end

  def contains?(object_to_find)
    @objects.include?(object_to_find)
  end

  def x(coordinate)
    Integer(coordinate.x*@scale)
  end

  def y(coordinate)
    Integer(coordinate.y*@scale)
  end
end