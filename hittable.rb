require_relative './vec3'
require_relative './interval'

# Encapsulates information about a HIT (i.e. a ray striking an object)
class HitRecord
  include VectorUtils

  def initialize
    # the Ray vector at the point of incidence. That is, P(t) = A + tb where t is known
    @p = nil

    # the material of the object that was hit by the ray
    @material = nil

    # value at which the ray hits the hittable object/surface. That is, the t in P(t) = A + tb
    @t = nil

    # Normal Vector passing through the point of incidence
    @normal = nil

    # True if ray is hitting object from the front side.
    @front_face = nil
  end
  attr_accessor :p, :normal, :t, :front_face, :material

  def set_face_normal(ray, outward_normal)
    # Sets the hit record normal vector
    # NOTE: the parameter outward_normal is assumed to have unit length

    @front_face = dot(ray.direction, outward_normal).negative?

    # Our convention shall be that normals shall be pointing against the ray
    @normal = @front_face ? outward_normal : -outward_normal
  end

  def copy_state_from(other_record)
    @p = other_record.p
    @t = other_record.t
    @normal = other_record.normal
    @front_face = other_record.front_face
    @material = other_record.material
  end
end

# @bstract Any object that can be "hit" subclasses Hittabble and implements #hit
class Hittable
  include VectorUtils

  # Returns true if the provided ray strikes the Hittable object.
  # It also adds information about the "hit" to the passed in hit_record
  #
  # @param ray [Ray]
  # @param ray_t [Interval]
  # @param hit_record [HitRecord]
  # @return [Boolean]
  def hit(ray, ray_t, hit_record)
    raise NotImplementedError
  end
end
