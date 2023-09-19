require_relative './vec3'
require_relative './color'

# Image
image_height = 256
image_width = 256

# Render
File.open('image.ppm', 'w') do |file|
  file << "P3\n" << image_width << ' ' << image_height << "\n255\n"

  (0...image_height).each do |row|
    print("\rScanlines remaining:  #{image_height - 1} ")

    (0...image_width).each do |col|
      pixel_color = Color.new(col.to_f / (image_width - 1), row.to_f / (image_height - 1), 0)
      ColorUtils.write_color(file, pixel_color)
    end
  end
end
