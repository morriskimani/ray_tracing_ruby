# Models a Ray i.e. a line with one fixed starting point and no endpoint.
# A ray can be described by the relation: P(t) = A + tb, where:
#   A -> A vector denoting the origin of the ray
#   b -> A vector denoting the direction of the ray
#   t -> A scalar used to arrive at a point on the ray
class Ray
  # @param origin [Vec3]
  # @param direction [Vec3]
  def initialize(origin, direction)
    @origin = origin
    @direction = direction
  end
  attr_reader :origin, :direction

  # @param t [Numeric]
  def at(t)
    origin + direction * t
  end
end
