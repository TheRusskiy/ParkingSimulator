class GraphicParkingSpot < Qt::GraphicsItem
  attr_accessor :assigned
  def initialize(coordinate, is_left, angle, spot_length)
    super(nil)
    @coordinate=coordinate
    @is_left=is_left
    @angle=angle
    @spot_length=spot_length

    @scale=1

    @boundingRect = create_bounding_rect
    @red = Qt::Color.new(255, 255, 0)
    @gray = Qt::Color.new(100, 100, 100)
    @brush = Qt::Brush.new(@gray)
    setRotation(@angle/Math::PI*180.0)
    @assigned=false
  end

  def create_bounding_rect
    side=@spot_length*@scale*4
    Qt::RectF.new(-side,-side,side,side)
  end

  def setScale(scale)
    super
    if scale!=@scale
      @scale=scale
      @boundingRect=create_bounding_rect
    end
  end

  def assigned=(value)
    @assigned=value
    if @assigned
      @brush = Qt::Brush.new(@red)
    else
      @brush = Qt::Brush.new(@gray)
    end
  end

  def boundingRect
    return @boundingRect
  end

  def paint(painter, arg, widget)
    x1=0
    y1=0
    x2=x1+@spot_length
    y2=y1+@spot_length
    if not @is_left; y2=y2-2*@spot_length; end
    painter.brush = @brush
    painter.drawRect(x1,y1, x2, y2)
  end
end