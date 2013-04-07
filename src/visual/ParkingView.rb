require_relative 'GraphicCar'
require_relative 'mouse'

class ParkingView < Qt::GraphicsView
  attr_reader :scene
  X=1000
  Y=400

  def initialize
    @scene =  Qt::GraphicsScene.new
    @scene.setSceneRect(0, 0, X, Y)
    @scene.itemIndexMethod = Qt::GraphicsScene::NoIndex

    car_count = 7;
    for i in 0...car_count do
      car = GraphicCar.new
      car.setPos(i*100, 100)
      @scene.addItem(car)
    end
    super(@scene)

    self.renderHint = Qt::Painter::Antialiasing
#view.backgroundBrush = Qt::Brush.new(Qt::Pixmap.new(":/images/cheese.jpg"))
    self.cacheMode = Qt::GraphicsView::CacheBackground
    self.dragMode = Qt::GraphicsView::ScrollHandDrag
    self.setWindowTitle(QT_TRANSLATE_NOOP(Qt::GraphicsView, "Parking simulator"))

    self.resize(X, Y)
  end

end