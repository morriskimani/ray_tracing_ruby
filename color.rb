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

      intensity = Interval.new(0.0, 0.999)

      stream \
        << (256 * intensity.clamp(r)).to_i << ' ' \
        << (256 * intensity.clamp(g)).to_i << ' ' \
        << (256 * intensity.clamp(b)).to_i << "\n"
    end
  end
end
