require 'Qt'
require 'awesome_print'
require_relative '../src/visual/window'
require_relative '../src/core'

app = Qt::Application.new(ARGV)
window = Window.new
core = Core.new(window.view)
window.show
core.start
app.exec