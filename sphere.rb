class Sphere < Hittable
  def initialize(center, radius, material)
    @center = center
    @radius = radius
    @material = material
  end

  def hit(ray, ray_t, hit_record)
    oc = ray.origin - @center
    a = ray.direction.length_squared
    half_b = dot(oc, ray.direction)
    c = oc.length_squared - @radius * @radius

    discriminant = half_b * half_b - a * c
    return false if discriminant.negative?

    sqrtd = Math.sqrt(discriminant)

    # find nearest root that lies in the acceptable range
    root = (-half_b - sqrtd) / a
    if !ray_t.surrounds?(root)
      root = (-half_b + sqrtd) / a
      return false if !ray_t.surrounds?(root)
    end

    hit_record.t = root
    hit_record.p = ray.at(root)
    hit_record.material = @material
    outward_normal = (hit_record.p - @center) / @radius
    hit_record.set_face_normal(ray, outward_normal)

    true
  end
end
