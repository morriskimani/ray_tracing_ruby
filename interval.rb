class Interval
  def initialize(min, max)
    @min = min
    @max = max
  end
  attr_reader :min, :max

  def includes?(value)
    @min <= value && value <= @max
  end

  def surrounds?(value)
    @min < value && value < @max
  end

  EMPTY = new(Float::INFINITY, -Float::INFINITY)
  UNIVERSE = new(-Float::INFINITY, Float::INFINITY)
end
