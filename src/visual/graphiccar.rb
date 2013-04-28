class GraphicCar < Qt::GraphicsItem
  attr_writer :car
  def initialize(length=4)
    super(nil)

    @car=nil

    @length=length
    @width=2
    @color = Qt::Color.new(rand(256), rand(256), rand(256))
    adj = 1
    # todo
    #@boundingRect = Qt::RectF.new(-20 - adjust, -22 - adjust,
    #                              40 + adjust, 83 + adjust)
    @boundingRect = Qt::RectF.new(0,0,length+adj,length+adj)
    @color = Qt::Color.new(rand(256), rand(256), rand(256))
    @brush = Qt::Brush.new(@color)
    setAcceptHoverEvents(true)
    @text = Qt::GraphicsTextItem.new("", self)
    showText
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
    #@text.setRotation(0-rotation)
    #@text.setScale(1.0/scale)
    #@text.setDefaultTextColor(@color)
    #@text.setPlainText(Integer(pos.x/scale).to_s+':'+Integer(pos.y/scale).to_s)
    #@text.adjustSize

    #if @draw_text; @text.show; else @text.hide; end;
    painter.brush = @brush
    painter.drawRoundedRect(0,0, @length, @width, 1,1)
  end

  def showText
    @draw_text=true
    @text.show
  end

  def hideText
    @draw_text=false
    @text.hide
  end
end

class GraphicTruck < GraphicCar
  def initialize(length=8)
    super
    @length=length
    @width=3
  end
end