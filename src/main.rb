require 'Qt'
require 'awesome_print'
require_relative '../src/visual/window'
require_relative '../src/core'
require_relative '../src/binder'

app = Qt::Application.new(ARGV)
window = Window.new
core = Core.new(window.view)
binder = Binder.new(core, window)
window.show
core.start
app.exec