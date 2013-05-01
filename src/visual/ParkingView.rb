require_relative 'GraphicCar'
#require_relative 'mouse'

class ParkingView < Qt::GraphicsView
  attr_reader :scene
  X=800
  Y=300

  def initialize(scene)
    @scene =  scene
    @scene.setSceneRect(50, 00, X, Y)
    @scene.itemIndexMethod = Qt::GraphicsScene::NoIndex
    #super.resetCachedContent
    super(@scene)


    self.renderHint = Qt::Painter::Antialiasing
#view.backgroundBrush = Qt::Brush.new(Qt::Pixmap.new(":/images/cheese.jpg"))
    self.cacheMode = Qt::GraphicsView::CacheBackground
    self.dragMode = Qt::GraphicsView::ScrollHandDrag
    self.setWindowTitle(QT_TRANSLATE_NOOP(Qt::GraphicsView, "Parking simulator"))

    #self.resize(X, Y)
  end

end