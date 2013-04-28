class GraphicCar < Qt::GraphicsItem
  attr_writer :car
  def initialize(length=4)
    super(nil)
    @car=nil
    @length=length
    @color = Qt::Color.new(rand(256), rand(256), rand(256))
    adj = 1
    @boundingRect = Qt::RectF.new(0,0,length+adj,length+adj)
    @color = Qt::Color.new(rand(256), rand(256), rand(256))
    @brush = Qt::Brush.new(@color)
    setAcceptHoverEvents(true)
    @text = Qt::GraphicsTextItem.new("", self)
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
    @polygon||=get_car_polygon
    if @draw_text;
      adjust_text_setting
      @text.show;
    else
      @text.hide;
    end;
    painter.brush = @brush
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
    @text.setDefaultTextColor(@color)
    @text.setPlainText(Integer(pos.x/scale).to_s+':'+Integer(pos.y/scale).to_s)
    @text.adjustSize
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