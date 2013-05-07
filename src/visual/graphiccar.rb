class GraphicCar < Qt::GraphicsItem
  attr_writer :car
  def initialize(length=4)
    super(nil)
    @car=nil
    @length=length
    @text_color = Qt::Color.new(0,0,0)
    #@text_brush = Qt::Brush.new(@text_color)
    adj = 1
    @boundingRect = Qt::RectF.new(0,0,length+adj,length+adj)
    @color = Qt::Color.new(rand(256), rand(256), rand(256))
    @brush = Qt::Brush.new(@color)
    setAcceptHoverEvents(true)
    @text = Qt::GraphicsSimpleTextItem.new("", self)
    @text.brush=Qt::Brush.new(@text_color)
    hideText
    setZValue(5)
  end

  def boundingRect
    return @boundingRect
  end

  def hoverEnterEvent(event)
    showText() unless @draw_text
  end

  def hoverLeaveEvent(event)
    if @draw_text; hideText; end
  end

  def paint(painter, arg, widget)
    #if @car.wants_to_park_time>0
    #  showText
    #else
    #  hideText
    #end
    @polygon||=get_car_polygon
    if @draw_text;
      adjust_text_setting
      @text.show;
    else
      @text.hide;
    end;
    painter.brush=@brush
    #rectangle:
    #painter.drawRoundedRect(0,0, @length, @width, 1,1)
    painter.drawPolygon(@polygon, 6)
  end

  def showText
    @draw_text=true
    @text.show
  end

  def hideText
    @draw_text=false
    @text.hide
  end

  def adjust_text_setting()
    @text.setRotation(0-rotation)
    @text.setScale(2.0/scale)
    spot_text=""
    if @car.assigned_spot
      spot_text=", #"+@car.assigned_spot.caption
    end
    @text.setText(@car.getModel.capitalize+', '+
                           (@car.wants_to_park_time/60/60).round.to_s+'h'+
                           ':'+(@car.wants_to_park_time/60%60).round.to_s+'m'+spot_text)
  end

  def get_car_polygon()
    @width = @car.width unless @car.nil?
    @length = @car.length unless @car.nil?
    points = Array.new
    points<<Qt::PointF.new(0,0)
    points<<Qt::PointF.new(@length/4.0*3.0,0)
    points<<Qt::PointF.new(@length,@width/2.0)
    points<<Qt::PointF.new(@length/4.0*3.0,@width)
    points<<Qt::PointF.new(0,@width)
    points<<Qt::PointF.new(0,0)
    Qt::PolygonF.new(points)
  end
end

class GraphicTruck < GraphicCar
  def initialize(length=8)
    super
    @length=length
  end
end