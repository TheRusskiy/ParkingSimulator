class GraphicRoad < Qt::GraphicsItem
  def initialize(x1, y1, x2, y2)
    super(nil)
    @x1=x1; @x2=x2; @y1=y1; @y2=y2
    @boundingRect = Qt::RectF.new(0, 0,
                                  (x2-x1).abs, (y2-y1).abs)
    @color = Qt::Color.new(30, 30, 30)
    @brush = Qt::Brush.new(@color)
  end

  def boundingRect
    return @boundingRect
  end

  def paint(painter, arg, widget)
    painter.brush = @brush
    painter.drawLine(@x1, @y1, @x2, @y2)
  end
end