class Vec3
  def initialize(x = nil, y = nil, z = nil)
    @x = x || 0
    @y = y || 0
    @z = z || 0
  end
  attr_reader :x, :y, :z

  def +(other)
    case other
    in Numeric
      add_num(other)
    in Vec3
      add_other(other)
    else
      raise TypeError, "Expected Numeric or #{self.class}, got #{other.class}"
    end
  end

  def -(other)
    self + -other
  end

  # Unary minus
  def -@
    Vec3.new(-@x, -@y, -@z)
  end

  def *(other)
    raise TypeError, "Expected a Numeric val, got #{other.class}" unless other.is_a? Numeric

    Vec3.new(@x * other, @y * other, @z * other)
  end

  def /(other)
    self * (1.0 / other)
  end

  def length
    length_squared**0.5
  end

  def length_squared
    @x * @x + @y * @y + @z * @z
  end

  def to_s
    "#{@x} #{@y} #{@z}"
  end

  private

  def add_num(num)
    Vec3.new(@x + num, @y + num, @z + num)
  end

  def add_other(other)
    Vec3.new(@x + other.x, @y + other.y, @z + other.z)
  end
end

Point3 = Vec3

module VectorUtils
  # Dot product of vectors u and v
  def dot(u, v)
    u.x * v.x + u.y * v.y + u.z * v.z
  end

  # Cross Product of vectors u and v
  def cross(u, v)
    Vec3.new(
      u.y * v.z - u.z * v.y,
      u.z * v.x - u.x * v.z,
      u.x * v.y - u.y * v.x
    )
  end

  def unit_vector(v)
    v / v.length
  end
end

