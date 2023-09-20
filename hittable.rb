require_relative './vec3'

class HitRecord
  include VectorUtils

  def initialize
    # the Ray vector. That is P(t) = A + tb, where the variable t is known and substituted in.
    @p = nil

    # value at which the ray function hits the hittable object/surface. That is, the t in P(t) = A + tb
    @t = nil

    # Normal Vector passing through the intersection point of the ray and the object
    @normal = nil

    # True if ray is hitting object from the front side.
    @front_face = nil
  end
  attr_accessor :p, :normal, :t, :front_face

  def set_face_normal(ray, outward_normal)
    # Sets the hit record normal vector
    # NOTE: the parameter outward_normal is assumed to have unit length

    @front_face = dot(ray.direction, outward_normal).negative?

    # Our convention shall be that normals shall be pointing against the ray
    @normal = @front_face ? outward_normal : -outward_normal
  end
end

class Hittable
  include VectorUtils

  def hit
    raise NotImplementedError
  end
end

class Sphere < Hittable
  def initialize(center, radius)
    @center = center
    @radius = radius
  end

  def hit(ray, ray_tmin, ray_tmax, hit_record)
    oc = ray.origin - @center
    a = ray.direction.length_squared
    half_b = dot(oc, ray.direction)
    c = oc.length_squared - @radius * @radius

    discriminant = half_b * half_b - a * c
    return false if discriminant.negative?

    sqrtd = Math.sqrt(discriminant)

    # find nearest root that lies in the acceptable range
    root = (-half_b - sqrtd) / a
    if root <= ray_tmin || ray_tmax <= root
      root = (-half_b + sqrtd) / a
      return false if root <= ray_tmin || ray_tmax <= root
    end

    hit_record.t = root
    hit_record.p = ray.at(root)
    outward_normal = (hit_record.p - @center) / @radius
    hit_record.set_face_normal(ray, outward_normal)

    true
  end
end
