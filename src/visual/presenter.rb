class Presenter
  require_relative 'GraphicCar'
  require_relative 'GraphicRoad'
  require '../src/road/car'
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
    Car.class_eval do
      attr_accessor :draw_item
    end
    Road.class_eval do
      attr_accessor :draw_item
    end
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
    end
  end


  def redraw
    for object in @objects
      case object.class.name
        when 'Road'
          draw_road(object)
      end
    end

    for object in @objects
      case object.class.name
        when 'Car'
          draw_car(object)
      end
    end

  end

  def draw_car(car)
    if car.placement.nil?
      @scene.removeItem(car.draw_item)
      @objects.delete(car)
      return
    end
    car.draw_item.setPos(x(car.coordinate), y(car.coordinate))
    car.draw_item.setRotation(car.state.rotation/Math::PI*180.0)
    car.draw_item.setScale(@scale)
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