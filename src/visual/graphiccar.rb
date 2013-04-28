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
    @text = Qt::GraphicsTextItem.new("sdasda", self)
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
    @text.setRotation(0-rotation)
    @text.setScale(1.0/scale)
    @text.setDefaultTextColor(@color)
    @text.setPlainText(Integer(pos.x/scale).to_s+':'+Integer(pos.y/scale).to_s+': space='+@car.state.get_available_space.round(2).to_s)
    @text.adjustSize
    #if @draw_text; @text.show; else @text.hide; end;
    painter.brush = @brush
    painter.drawRoundedRect(0,0, @length, @width, 1,1)
    #if @draw_text; painter.drawText(0, 0, 5, 5, Qt::TextSingleLine, "sdaasd") end
    #setVisible(true)
    #setPos(rand(100), rand(100))
    #painter.drawRect(0,30, 10, 20)
    #painter.drawText(0, 0, "dsasda")

    ## Body
    #painter.brush = Qt::Brush.new(@color)
    #painter.drawEllipse(-10, -20, 20, 40)
    #
    ## Eyes
    #painter.brush = Qt::Brush.new(Qt::white)
    #painter.drawEllipse(-10, -17, 8, 8)
    #painter.drawEllipse(2, -17, 8, 8)
    #
    ## Nose
    #painter.brush = Qt::Brush.new(Qt::black)
    #painter.drawEllipse(Qt::RectF.new(-2, -22, 4, 4))
    #
    ## Pupils
    #painter.drawEllipse(Qt::RectF.new(-8.0 + @mouseEyeDirection, -17, 4, 4))
    #painter.drawEllipse(Qt::RectF.new(4.0 + @mouseEyeDirection, -17, 4, 4))
    #
    ###Ears
    ##painter.brush = Qt::Brush.new(scene.collidingItems(self).empty? ? Qt::darkYellow : Qt::red)
    ##painter.drawEllipse(-17, -12, 16, 16)
    ##painter.drawEllipse(1, -12, 16, 16)
    #
    ## Tail
    #path = Qt::PainterPath.new(Qt::PointF.new(0, 20))
    #path.cubicTo(-5, 22, -5, 22, 0, 25)
    #path.cubicTo(5, 27, 5, 32, 0, 30)
    #path.cubicTo(-5, 32, -5, 42, 0, 35)
    #painter.brush = Qt::NoBrush
    #painter.drawPath(path)
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