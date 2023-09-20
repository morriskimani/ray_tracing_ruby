require_relative './vec3'

HitRecord = Struct.new('HitRecord', p, normal, t)

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
    hit_record.normal = (hit_record.p - @center) / @radius

    true
  end
end
