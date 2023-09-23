class Vec3
  class << self
    def random(min = nil, max = nil)
      return Vec3.new(rand, rand, rand) if min.nil? || max.nil?

      clamped_rand = -> { min + (max - min) * rand }
      Vec3.new(clamped_rand.call, clamped_rand.call, clamped_rand.call)
    end
  end

  def initialize(x = nil, y = nil, z = nil)
    @x = x || 0
    @y = y || 0
    @z = z || 0
  end
  attr_reader :x, :y, :z

  def +(other)
    case other
    in Numeric
      Vec3.new(@x + other, @y + other, @z + other)
    in Vec3
      Vec3.new(@x + other.x, @y + other.y, @z + other.z)
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
    case other
    in Numeric
      Vec3.new(@x * other, @y * other, @z * other)
    in Vec3
      Vec3.new(@x * other.x, @y * other.y, @z * other.z)
    else
      raise TypeError, "Expected Numeric or #{self.class}, got #{other.class}"
    end
  end

  def /(other)
    self * (1.0 / other)
  end

  def length
    Math.sqrt(length_squared)
  end

  def length_squared
    @x * @x + @y * @y + @z * @z
  end

  def to_s
    "#{@x} #{@y} #{@z}"
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

  def random_unit_vector
    unit_vector(random_in_unit_sphere)
  end

  # Generate a random vector inside a unit sphere
  def random_in_unit_sphere
    vector = Vec3.random
    vector = Vec3.random until vector.length_squared < 1
    vector
  end

  def random_on_hemisphere(normal)
    generated_vector = random_unit_vector

    return generated_vector if dot(generated_vector, normal).positive? # generated_vector on same hemisphere as normal

    -generated_vector
  end
end
