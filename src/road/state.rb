class State
  attr_accessor :rotation

  def initialize
    @rotation=0
    @parked = false
  end

  def set_available_space(space)
    @space = space
  end

  def get_available_space
    return @space
  end

  def parked?
    @parked
  end

  def parked=(value)
    @parked=value
  end
end