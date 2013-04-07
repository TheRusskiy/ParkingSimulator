class Presenter
  require_relative 'GraphicCar'
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
        object.draw_item = GraphicCar.new
        @scene.addItem(object.draw_item)
      when 'Car'
        object.draw_item = GraphicCar.new
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
    car.draw_item.setPos(x(car.coordinate), y(car.coordinate))
    car.draw_item.setRotation(car.state.rotation/Math::PI*180.0)
    car.draw_item.setScale(@scale)
    #car.draw_item.setRotation(car.state.rotation) todo
  end

  def draw_road(road)
    
  end

  def contains?(object_to_find)
    @objects.include?(object_to_find)
  end

  def x(coordinate)
    Integer(coordinate.get_x*@scale)
  end

  def y(coordinate)
    Integer(coordinate.get_y*@scale)
  end
end