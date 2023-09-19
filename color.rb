require_relative './vec3'

Color = Vec3

module ColorUtils
  class << self
    def write_color(stream, color)
      stream \
        << (color.x * 255.999).to_i << ' ' \
        << (color.y * 255.999).to_i << ' ' \
        << (color.z * 255.999).to_i << "\n"
    end
  end
end
