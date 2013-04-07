require 'Qt'
require 'awesome_print'
require '../src/visual/window'

app = Qt::Application.new(ARGV)
window = Window.new
window.show
app.exec