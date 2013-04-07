require_relative 'borderlayout'
require_relative 'parkingview'
	
class Window < Qt::Widget
	
	def initialize(parent = nil)
		super

    view = ParkingView.new

	
	    self.layout = BorderLayout.new do |l|
			l.addWidget(view, BorderLayout::Center)
			l.addWidget(createLabel("North"), BorderLayout::North)
			l.addWidget(createLabel("West"), BorderLayout::West)
			l.addWidget(createLabel("East"), BorderLayout::East)
			l.addWidget(createLabel("South"), BorderLayout::South)
		end
	
	    setWindowTitle(tr("Border Layout"))
	end
	
	def createLabel(text)
	    label = Qt::Label.new(text)
	    label.frameStyle = Qt::Frame::Box | Qt::Frame::Raised
	    return label
	end
end
