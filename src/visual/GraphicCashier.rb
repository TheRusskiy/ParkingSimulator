class GraphicCashier < Qt::GraphicsItem
  def initialize(scene, cashier)
    super(nil)
    @cashier = cashier
    @boundingRect = Qt::RectF.new(-1, -1, 1, 1)
    @gray = Qt::Color.new(200, 200, 200)
    @brush = Qt::Brush.new(@gray)
    setCacheMode(0)
    setZValue(0)
    #@text = Qt::GraphicsTextItem.new("", self)
    @scene = scene
  end


  def setScale(scale)
    super
    if scale!=@scale
      @scale=scale
    end
  end

  def boundingRect
    return @boundingRect
  end

  def paint(painter, arg, widget)
    #@text.setScale(2.0/scale)
    #@cashier.night? ? @text.setPlainText("Night") : @text.setPlainText("Day")
    painter.brush = @brush
    @brush.color=color_of_day()
    @scene.setBackgroundBrush(@brush)
  end

  def color_of_day
    lightest = 4 * 60 # hours * min
    curr_time = (@cashier.time.hour-4)%24 * 60 + @cashier.time.min
    curr_time = (curr_time - 12 * 60).abs
    modifier = 255.0 * (curr_time/(12*60.0))
    c=255-modifier
    #c2=255-modifier*0.5
    color = Qt::Color.new(c,c,modifier,255)
  end
end