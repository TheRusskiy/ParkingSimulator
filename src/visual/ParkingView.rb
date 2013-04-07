class ParkingView < Qt::GraphicsView
  def initialize
    scene =  Qt::GraphicsScene.new
    scene.setSceneRect(0, 0, 1024, 768)
    scene.itemIndexMethod = Qt::GraphicsScene::NoIndex
    super(scene)

    #view = Qt::GraphicsView.new(scene)
    self.renderHint = Qt::Painter::Antialiasing
#view.backgroundBrush = Qt::Brush.new(Qt::Pixmap.new(":/images/cheese.jpg"))
    self.cacheMode = Qt::GraphicsView::CacheBackground
    self.dragMode = Qt::GraphicsView::ScrollHandDrag
    self.setWindowTitle(QT_TRANSLATE_NOOP(Qt::GraphicsView, "Parking simulator"))


    @shapeLabel = Qt::Label.new('Shape:')
    self.layout = Qt::GridLayout.new do |l|
      l.addWidget(@shapeLabel, 1, 0)
    end

    self.resize(1024, 768)
  end
end
#setPos(mapToParent(0, -(3 + Math.sin(@speed) * 3)))