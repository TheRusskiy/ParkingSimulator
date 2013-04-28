require_relative 'borderlayout'
require_relative 'parkingview'
	
class Window < Qt::MainWindow
  attr_reader :view

  #slots 'pointClicked()'

  def initialize()
		super
    @w = Qt::Widget.new
    setCentralWidget(@w)

    @view = ParkingView.new(Qt::GraphicsScene.new)
    @w.layout = Qt::GridLayout.new do |l|
      l.addWidget(@view, 0, 0)
      l.addWidget(createControlGroupBox, 1, 0)
      #l.addWidget(createGridGroupBox, 1, 1)
    end
    adjustWindowSize(@w)
    createMenus
    createStatusBar
	  setWindowTitle('Parking lot simulator')
    resize(@w.width, @w.height)
	end

  def adjustWindowSize(item)
    h=0
    w=0
    #item=self
    for i in 0...item.layout.count
      h=h+item.layout.itemAt(i).sizeHint.height
      w1 = item.layout.itemAt(i).sizeHint.width
      w = w < w1 ? w1 : w
    end
    item.resize(w+100, h+200)
  end

  def createLabel(text)
	    label = Qt::Label.new(text)
	    label.frameStyle = Qt::Frame::Box | Qt::Frame::Raised
	    return label
  end

  def createControlGroupBox
    layout = Qt::GridLayout.new
    box = Qt::GroupBox.new("Control Panel")
    layout.addWidget w1=createTimeControls(), 0, 0, 1, 2
    layout.addWidget w2=createUniformControls(), 0, 2, 1, 1
    layout.addWidget w3=createNormalControls(), 0, 3, 1, 1
    layout.addWidget w4=createExponentialControls(), 0, 4, 1, 1
    layout.addWidget w5=createDeterminedControls(), 0, 5, 1, 1
    layout.addWidget w6=createPriceControls(), 0, 6, 1, 1
    w2.setVisible(false)
    w3.setVisible(false)
    w4.setVisible(false)

    box.layout=layout
    return box
  end

  def createTimeControls()
    layout = Qt::GridLayout.new
    box = Qt::GroupBox.new('Model properties')
    #Simulation speed:
    @sim_speed=[1, 20, 6]
    simSpeedLabel = Qt::Label.new(tr("Simulation speed %d..%d:" % [@sim_speed[0], @sim_speed[1]]))
    simSpeedSpinBox = Qt::SpinBox.new do |i|
      i.range = @sim_speed[0]..@sim_speed[1]
      i.singleStep = 1
      i.value = @sim_speed[2]
      i.suffix = 'x real time'
    end
    #Road speed:
    @car_speed=[1, 20, 10]
    carSpeedLabel = Qt::Label.new(tr("Car road speed %d..%d:" % [@car_speed[0], @car_speed[1]]))
    carSpeedSpinBox = Qt::SpinBox.new do |i|
      i.range = @car_speed[0]..@car_speed[1]
      i.singleStep = 1
      i.value = @car_speed[2]
      i.suffix = ' km/h'
    end
    #Parking road speed:
    @car_pspeed=[1, 20, 5]
    carPSpeedLabel = Qt::Label.new(tr("Car parking speed %d..%d:" % [@car_pspeed[0], @car_pspeed[1]]))
    carPSpeedSpinBox = Qt::SpinBox.new do |i|
      i.range = @car_pspeed[0]..@car_pspeed[1]
      i.singleStep = 1
      i.value = @car_pspeed[2]
      i.suffix = ' km/h'
    end
    #Discretization:
    @diskret=[1, 10, 5]
    diskretLabel = Qt::Label.new(tr("Discretization %d..%d:" % [@diskret[0], @diskret[1]]))
    diskretSpinBox = Qt::SpinBox.new do |i|
      i.range = @diskret[0]..@diskret[1]
      i.singleStep = 1
      i.value = @diskret[2]
      i.suffix = ' times in a second'
    end
    #Parking time scale:
    @pscale=[60, 3600, 600]
    pScaleLabel = Qt::Label.new(tr("Time scale %d..%d:" % [@pscale[0], @pscale[1]]))
    pScaleSpinBox = Qt::SpinBox.new do |i|
      i.range = @pscale[0]..@pscale[1]
      i.singleStep = 60
      i.value = @pscale[2]
      i.prefix = 'parking = '
      i.suffix = 'x road'
    end
    #Minimal parking time:
    @min_park=[1, 1440, 60]
    pMinLabel = Qt::Label.new(tr("Minimal parking time %d..%d:" % [@min_park[0], @min_park[1]]))
    pMinSpinBox = Qt::SpinBox.new do |i|
      i.range = @min_park[0]..@min_park[1]
      i.singleStep = 1
      i.value = @min_park[2]
      i.suffix = ' minutes'
    end
    #Maximal parking time:
    @max_park=[0, 1440, 240]
    pMaxLabel = Qt::Label.new(tr("Maximal parking time %d..%d:" % [@max_park[0], @max_park[1]]))
    pMaxSpinBox = Qt::SpinBox.new do |i|
      i.range = @max_park[0]..@max_park[1]
      i.singleStep = 60
      i.value = @max_park[2]
      i.prefix = 'minimal + '
      i.suffix = ' minutes'
    end
    #Safe gap:
    @p_safe=[1, 5, 1]
    pSafeLabel = Qt::Label.new(tr("Gap between cars %d..%d:" % [@p_safe[0], @p_safe[1]]))
    pSafeSpinBox = Qt::SpinBox.new do |i|
      i.range = @p_safe[0]..@p_safe[1]
      i.singleStep = 1
      i.value = @p_safe[2]
      i.suffix = ' meters'
    end
    @applyControlsButton = createButton("Apply", SLOT('applyControls()'))
    @startStopControlsButton = createButton("Start/Stop", SLOT('startStop()'), "Start/Stop simulation")
    layout.addWidget(simSpeedLabel, 0, 0)
    layout.addWidget(simSpeedSpinBox, 1, 0)
    layout.addWidget(carSpeedLabel, 2, 0)
    layout.addWidget(carSpeedSpinBox, 3, 0)
    layout.addWidget(carPSpeedLabel, 4, 0)
    layout.addWidget(carPSpeedSpinBox, 5, 0)
    layout.addWidget(diskretLabel, 6, 0)
    layout.addWidget(diskretSpinBox, 7, 0)
    layout.addWidget(pScaleLabel, 0, 1)
    layout.addWidget(pScaleSpinBox, 1, 1)
    layout.addWidget(pMinLabel, 2, 1)
    layout.addWidget(pMinSpinBox, 3, 1)
    layout.addWidget(pMaxLabel, 4, 1)
    layout.addWidget(pMaxSpinBox, 5, 1)
    layout.addWidget(pSafeLabel, 6, 1)
    layout.addWidget(pSafeSpinBox, 7, 1)
    layout.addWidget(@applyControlsButton, 8, 0)
    layout.addWidget(@startStopControlsButton, 8, 1)
    box.layout=layout
    return box
  end

  def createUniformControls()
    layout = Qt::GridLayout.new
    box = Qt::GroupBox.new('Uniform distribution controls')
    #T:
    @uniform_t=[1, 600, 20]
    uniformTLabel = Qt::Label.new(tr("T %d..%d:" % [@uniform_t[0], @uniform_t[1]]))
    uniformTSpinBox = Qt::SpinBox.new do |i|
      i.range = @uniform_t[0]..@uniform_t[1]
      i.singleStep = 1
      i.value = @uniform_t[2]
      i.prefix = '0..'
      i.suffix = ' seconds'
    end
    @applyUniformButton = createButton("Apply", SLOT('applyUniform()'))
    layout.addWidget(uniformTLabel, 0, 0)
    layout.addWidget(uniformTSpinBox, 1, 0)
    layout.addWidget(@applyUniformButton, 2, 0)
    layout.setRowStretch(3, 1)

    box.layout=layout
    return box
  end

  def createNormalControls()
    layout = Qt::GridLayout.new
    box = Qt::GroupBox.new('Normal distribution controls')
    #Mean (location):
    @normal_mean=[0, 100, 50]
    normalMeanLabel = Qt::Label.new(tr("Mean (location) %d..%d:" % [@normal_mean[0], @normal_mean[1]]))
    normalMeanSpinBox = Qt::DoubleSpinBox.new do |i|
      i.range = @normal_mean[0]..@normal_mean[1]
      i.singleStep = 1
      i.value = @normal_mean[2]
      i.suffix = ' %'
    end
    #Variance (squared scale):
    @normal_variance=[0, 100, 10]
    varianceLabel = Qt::Label.new(tr("Variance (squared scale) %d..%d:" % [@normal_variance[0], @normal_variance[1]]))
    varianceSpinBox = Qt::DoubleSpinBox.new do |i|
      i.range = @normal_variance[0]..@normal_variance[1]
      i.singleStep = 1
      i.value = @normal_variance[2]
      i.suffix = ' %'
    end
    @applyNormalButton = createButton("Apply", SLOT('applyNormal()'))
    layout.addWidget(normalMeanLabel, 0, 0)
    layout.addWidget(normalMeanSpinBox, 1, 0)
    layout.addWidget(varianceLabel, 2, 0)
    layout.addWidget(varianceSpinBox, 3, 0)
    layout.addWidget(@applyNormalButton, 4, 0)
    layout.setRowStretch(5, 1)

    box.layout=layout
    return box
  end

  def createExponentialControls()
    layout = Qt::GridLayout.new
    box = Qt::GroupBox.new('Exponential distribution controls')
    #Scale (=1/Rateλ):
    @scale=[1, 100, 20]
    scaleLabel = Qt::Label.new(tr("Scale %d..%d:" % [@scale[0], @scale[1]]))
    scaleSpinBox = Qt::DoubleSpinBox.new do |i|
      i.range = @scale[0]..@scale[1]
      i.singleStep = 1
      i.value = @scale[2]
      i.prefix = 'Rate(lambda) = 1 / '
    end
    @applyExponentialButton = createButton("Apply", SLOT('applyExponential()'))
    layout.addWidget(scaleLabel, 0, 0)
    layout.addWidget(scaleSpinBox, 1, 0)
    layout.addWidget(@applyExponentialButton, 2, 0)
    layout.setRowStretch(3, 1)
    box.layout=layout
    return box
  end

  def createDeterminedControls()
    layout = Qt::GridLayout.new
    box = Qt::GroupBox.new('Determined flow controls')
    #Time interval:
    @determined=[1, 1000, 20]
    determinedLabel = Qt::Label.new(tr("Time interval %d..%d:" % [@determined[0], @determined[1]]))
    determinedSpinBox = Qt::SpinBox.new do |i|
      i.range = @determined[0]..@determined[1]
      i.singleStep = 1
      i.value = @determined[2]
      i.prefix = 'every '
      i.suffix = ' seconds'
    end
    @applyDeterminedButton = createButton("Apply", SLOT('applyDetermined()'))
    layout.addWidget(determinedLabel, 0, 0)
    layout.addWidget(determinedSpinBox, 1, 0)
    layout.addWidget(@applyDeterminedButton, 2, 0)
    layout.setRowStretch(3, 1)
    box.layout=layout
    return box
  end

  def createPriceControls()
    layout = Qt::GridLayout.new
    box = Qt::GroupBox.new('Price controls')
    #Domestic car:
    @domestic_price=[1, 100, 5]
    domesticLabel = Qt::Label.new(tr("Domestic car price %d..%d:" % [@domestic_price[0], @domestic_price[1]]))
    domesticSpinBox = Qt::DoubleSpinBox.new do |i|
      i.range = @domestic_price[0]..@domestic_price[1]
      i.singleStep = 1
      i.value = @domestic_price[2]
      i.suffix = ' $ / hour'
    end
    #Imported car:
    @import_price=[1, 100, 10]
    importLabel = Qt::Label.new(tr("Import car price %d..%d:" % [@import_price[0], @import_price[1]]))
    importSpinBox = Qt::DoubleSpinBox.new do |i|
      i.range = @import_price[0]..@import_price[1]
      i.singleStep = 1
      i.value = @import_price[2]
      i.suffix = ' $ / hour'
    end
    #Truck price:
    @truck_price=[1, 100, 10]
    truckLabel = Qt::Label.new(tr("Truck price %d..%d:" % [@truck_price[0], @truck_price[1]]))
    truckSpinBox = Qt::DoubleSpinBox.new do |i|
      i.range = @truck_price[0]..@truck_price[1]
      i.singleStep = 1
      i.value = @truck_price[2]
      i.suffix = ' $ / hour'
    end
    #Night discount:
    @night_price=[1, 100, 60]
    nightLabel = Qt::Label.new(tr("Night discount %d..%d:" % [@night_price[0], @night_price[1]]))
    nightSpinBox = Qt::SpinBox.new do |i|
      i.range = @night_price[0]..@night_price[1]
      i.singleStep = 1
      i.value = @night_price[2]
      i.suffix = '% of day price'
    end
    @applyPricesButton = createButton("Apply", SLOT('applyPrices()'))
    layout.addWidget(domesticLabel, 0, 0)
    layout.addWidget(domesticSpinBox, 1, 0)
    layout.addWidget(importLabel, 2, 0)
    layout.addWidget(importSpinBox, 3, 0)
    layout.addWidget(truckLabel, 4, 0)
    layout.addWidget(truckSpinBox, 5, 0)
    layout.addWidget(nightLabel, 6, 0)
    layout.addWidget(nightSpinBox, 7, 0)
    layout.addWidget(@applyPricesButton, 8, 0)
    layout.setRowStretch(9, 1)
    box.layout=layout
    return box
  end



  def createButton(text, member, tip=nil)
    button = Qt::ToolButton.new()
    button.setText(text)
    connect(button, SIGNAL('clicked()'), self, member)
    button.statusTip = tip unless tip.nil?
    return button
  end

  def createStatusBar()
    statusBar().showMessage("Welcome!")
  end

  def createMenus()
    @exitAct = Qt::Action.new("Exit", self)
    @exitAct.shortcut = Qt::KeySequence.new( tr("Ctrl+X") )
    @exitAct.statusTip = "Get the hell out of here!"
    connect(@exitAct, SIGNAL('triggered()'), self, SLOT('closeProgram()'))
    @fileMenu = menuBar().addMenu("File")
    #@fileMenu.addSeparator()
    @fileMenu.addAction(@exitAct)

    @viewMenu = menuBar().addMenu("Distribution")
    @selectUniformAct = Qt::Action.new("Uniform", self)
    @selectUniformAct.statusTip = "Set uniform distribution"
    @viewMenu.addAction(@selectUniformAct)
    connect(@selectUniformAct, SIGNAL('triggered()'), self, SLOT('selectUniform()'))

    @selectExponentialAct = Qt::Action.new("Exponential", self)
    @selectExponentialAct.statusTip = "Set exponential distribution"
    @viewMenu.addAction(@selectExponentialAct)
    connect(@selectExponentialAct, SIGNAL('triggered()'), self, SLOT('selectExponential()'))

    @selectNormalAct = Qt::Action.new("Uniform", self)
    @selectNormalAct.statusTip = "Set normal distribution"
    @viewMenu.addAction(@selectNormalAct)
    connect(@selectNormalAct, SIGNAL('triggered()'), self, SLOT('selectNormal()'))

    @selectDeterminedAct = Qt::Action.new("Determined", self)
    @selectDeterminedAct.statusTip = "Set determined flow"
    @viewMenu.addAction(@selectDeterminedAct)
    connect(@selectDeterminedAct, SIGNAL('triggered()'), self, SLOT('selectDetermined()'))

    @setScaleAct = Qt::Action.new("Choose scale", self)
    @setScaleAct.statusTip = "Choose a new scale from a dialog"
    @viewMenu = menuBar().addMenu("View")
    @viewMenu.addAction(@setScaleAct)

    #@formatMenu = @viewMenu.addMenu("Scale")
    #@formatMenu.addAction(@boldAct)

    @helpMenu = menuBar().addMenu("Help")
    @helpMenu.addAction(@aboutAct)
    @helpMenu.addAction(@helpAct)
  end
end
