require_relative './vec3'

Color = Vec3

module ColorUtils
  class << self
    def write_color(stream, pixel_color, samples_per_pixel)
      r = pixel_color.x
      g = pixel_color.y
      b = pixel_color.z

      # Average the samples
      scale = 1.0 / samples_per_pixel
      r *= scale
      g *= scale
      b *= scale

      # Apply linear to gamma transform
      r = linear_to_gamma(r)
      g = linear_to_gamma(g)
      b = linear_to_gamma(b)

      intensity = Interval.new(0.0, 0.999)

      stream \
        << (256 * intensity.clamp(r)).to_i << ' ' \
        << (256 * intensity.clamp(g)).to_i << ' ' \
        << (256 * intensity.clamp(b)).to_i << "\n"
    end

    # Transform from linear space to Gamma space

    def linear_to_gamma(linear_component)
      Math.sqrt(linear_component)
    end
  end
end
