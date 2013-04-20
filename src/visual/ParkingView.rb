require_relative 'GraphicCar'
#require_relative 'mouse'

class ParkingView < Qt::GraphicsView
  attr_reader :scene
  X=1000
  Y=400

  def initialize(scene)
    @scene =  scene
    @scene.setSceneRect(0, 0, X, Y)
    @scene.itemIndexMethod = Qt::GraphicsScene::NoIndex


    #car_count = 7;
    #for i in 0...car_count do
    #  car = GraphicCar.new
    #  car.setPos(i*100, 100)
    #  @scene.addItem(car)
    #end
    a1=@scene.addText('(0, 0)')
    a1.setPos(0, 0)
    a2=@scene.addText('(100, 0)')
    a2.setPos(100, 0)
    a3=@scene.addText('(0, 100)')
    a3.setPos(0, 100)
    a4=@scene.addText('(100, 100)')
    a4.setPos(100, 100)
    #super.resetCachedContent
    super(@scene)


    self.renderHint = Qt::Painter::Antialiasing
#view.backgroundBrush = Qt::Brush.new(Qt::Pixmap.new(":/images/cheese.jpg"))
    self.cacheMode = Qt::GraphicsView::CacheBackground
    self.dragMode = Qt::GraphicsView::ScrollHandDrag
    self.setWindowTitle(QT_TRANSLATE_NOOP(Qt::GraphicsView, "Parking simulator"))

    self.resize(X, Y)
  end

end