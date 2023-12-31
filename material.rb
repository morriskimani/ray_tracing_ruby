require_relative './vec3'

# @abstract Subclass and override #scatter to implement a custom material
class Material
  include VectorUtils

  ScatterRecord = Struct.new(
    'ScatterRecord',
    :scattered_ray,
    :attenuation, # attenuation of the scattered ray
    :is_scattered # true if the ray was scattered
  )

  def initialize(*)
    @scatter_record = ScatterRecord.new
  end

  # Scatter a ray (r_in) that has hit the material.
  #
  # @param r_in [Ray] the incident ray
  # @param hit_record [HitRecord] information about the incidence.
  # @return [ScatterRecord]
  def scatter(r_in, hit_record)
    raise NotImplementedError
  end

  protected

  attr_reader :scatter_record
end

# Models a Lambertian material (A diffuse surface)
# Such a material scatters incident illumination equally in all directions.
class Lambertian < Material
  def initialize(albedo)
    super
    @albedo = albedo
  end

  def scatter(_, hit_record)
    scatter_direction = hit_record.normal + random_unit_vector

    # Ignore degenerate scatter directions.
    scatter_direction = hit_record.normal if scatter_direction.near_zero?

    scatter_record.scattered_ray = Ray.new(hit_record.p, scatter_direction)
    scatter_record.attenuation = @albedo
    scatter_record.is_scattered = true

    scatter_record
  end
end

# Models materials that have polished surfaces
class Metal < Material
  def initialize(albedo, fuzz)
    super
    @albedo = albedo
    @fuzz = fuzz < 1 ? fuzz : 1
  end

  def scatter(r_in, hit_record)
    reflected = reflect(unit_vector(r_in.direction), hit_record.normal)

    scatter_record.scattered_ray = Ray.new(hit_record.p, reflected + random_unit_vector * @fuzz)
    scatter_record.attenuation = @albedo
    scatter_record.is_scattered = dot(scatter_record.scattered_ray.direction, hit_record.normal).positive?

    scatter_record
  end
end

# Models a dielectric material
class Dielectric < Material
  def initialize(refractive_index)
    super
    @refractive_index = refractive_index
  end

  def scatter(r_in, hit_record)
    refraction_ratio = hit_record.front_face ? (1.0 / @refractive_index) : @refractive_index
    unit_direction = unit_vector(r_in.direction)
    cos_theta = [dot(-unit_direction, hit_record.normal), 1.0].min
    sin_theta = Math.sqrt(1 - cos_theta * cos_theta)
    cannot_refract = refraction_ratio * sin_theta > 1

    direction = if cannot_refract || reflectance(cos_theta, refraction_ratio) > rand
                  reflect(unit_direction, hit_record.normal) # Total internal reflection
                else
                  refract(unit_direction, hit_record.normal, refraction_ratio)
                end

    scatter_record.scattered_ray = Ray.new(hit_record.p, direction)
    scatter_record.attenuation = Color.new(1, 1, 1)
    scatter_record.is_scattered = true

    scatter_record
  end

  private

  # Use Schlick's approximation for reflectance: https://en.wikipedia.org/wiki/Schlick%27s_approximation
  def reflectance(cosine, ref_idx)
    r0 = (1 - ref_idx) / (1 + ref_idx)
    r0 *= r0
    r0 + (1 - r0) * ((1 - cosine)**5)
  end
end
