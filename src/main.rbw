require 'Qt'
require 'awesome_print'
require_relative 'visual/window'
require_relative 'core'
require_relative 'parking_controller'

app = Qt::Application.new(ARGV)
window = Window.new()
core = Core.new(window.view)
controller = ParkingController.new(core, window)
window.show
#core.start
app.exec