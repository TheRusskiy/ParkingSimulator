require_relative 'graphiccar'
require_relative 'mouse'

class ParkingView < Qt::GraphicsView
  def initialize
    scene =  Qt::GraphicsScene.new
    scene.setSceneRect(0, 0, 1024, 768)
    #scene.setSceneRect(-300, -300, 600, 600)
    scene.itemIndexMethod = Qt::GraphicsScene::NoIndex


    car_count = 7;
    for i in 0...car_count do
      car = GraphicCar.new
      car.setPos(i*100, 100)
      scene.addItem(car)
    end
    super(scene)

    #mouse = GraphicCar.new
    #mouse.setPos(300,300)
    #scene.addItem(mouse)
    #
    #mouse.setPos(mouse.mapToParent(0, -(3 + Math.sin(10) * 3)))


    self.renderHint = Qt::Painter::Antialiasing
#view.backgroundBrush = Qt::Brush.new(Qt::Pixmap.new(":/images/cheese.jpg"))
    self.cacheMode = Qt::GraphicsView::CacheBackground
    self.dragMode = Qt::GraphicsView::ScrollHandDrag
    self.setWindowTitle(QT_TRANSLATE_NOOP(Qt::GraphicsView, "Parking simulator"))

    #@shapeLabel = Qt::Label.new('Shape:')
    #self.layout = Qt::GridLayout.new do |l|
    #  l.addWidget(@shapeLabel, 1, 0)
    #end

    self.resize(1024, 768)
    #self.resize(400, 300)
  end
end
#setPos(mapToParent(0, -(3 + Math.sin(@speed) * 3)))