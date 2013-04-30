require 'Qt'
require 'awesome_print'
require_relative '../src/visual/window'
require_relative '../src/core'
require_relative '../src/parking_controller'

app = Qt::Application.new(ARGV)
window = Window.new()
core = Core.new(window.view)
controller = ParkingController.new(core, window)
window.show
#core.start
app.exec