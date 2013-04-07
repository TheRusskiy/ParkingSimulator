require 'Qt'
require 'awesome_print'
require '../src/visual/window'
require '../src/core'

app = Qt::Application.new(ARGV)
window = Window.new
core = Core.new(window.view)
window.show
core.start
app.exec