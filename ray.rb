class Ray
  def initialize(origin, direction)
    @origin = origin
    @direction = direction
  end
  attr_reader :origin, :direction

  def at(t)
    origin + direction * t
  end
end
