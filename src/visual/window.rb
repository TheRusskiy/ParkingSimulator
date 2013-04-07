require_relative 'borderlayout'
require_relative 'parkingview'
	
class Window < Qt::Widget

  def initialize(parent = nil)
		super
    view = ParkingView.new
    self.layout = Qt::GridLayout.new do |l|
      l.addWidget(view, 0, 0)
      l.addWidget(createGridGroupBox)
    end
    adjustWindowSize()
	  setWindowTitle('Parking lot simulator')
	end

  def adjustWindowSize
    h=0
    w=0
    for i in 0...self.layout.count
      h=h+self.layout.itemAt(i).sizeHint.height
      w1 = self.layout.itemAt(i).sizeHint.width
      w = w < w1 ? w1 : w
    end
    self.resize(w+100, h+100)
  end

  def createLabel(text)
	    label = Qt::Label.new(text)
	    label.frameStyle = Qt::Frame::Box | Qt::Frame::Raised
	    return label
  end

  def createGridGroupBox()
    num_grid_rows = 3
    @labels = []
    @lineEdits = []
    @gridGroupBox = Qt::GroupBox.new("Grid layout")
    layout = Qt::GridLayout.new

    (0...num_grid_rows).each do |i|
      @labels[i] = Qt::Label.new(tr("Line %d:" % (i + 1)))
      @lineEdits[i] = Qt::LineEdit.new
      layout.addWidget(@labels[i], i, 0)
      layout.addWidget(@lineEdits[i], i, 1)
    end

    @smallEditor = Qt::TextEdit.new
    @smallEditor.setPlainText(tr("This widget takes up about two thirds of the " +
                                     "grid layout."))
    layout.addWidget(@smallEditor, 0, 2, 3, 1)

    layout.setColumnStretch(1, 10)
    layout.setColumnStretch(2, 20)
    @gridGroupBox.layout = layout
    return @gridGroupBox
  end
end
