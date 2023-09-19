image_height = 256
image_width = 256

File.open('image.ppm', 'w') do |file|
  file << "P3\n" << image_width << ' ' << image_height << "\n255\n"

  (0...image_height).each do |row|
    (0...image_width).each do |col|
      r = col.to_f / (image_width - 1)
      g = row.to_f / (image_height - 1)
      b = 0

      color_to_int = ->(color) { (255.999 * color).to_i }

      ir, ig, ib = [r, g, b].map(&color_to_int)

      file << ir << ' ' << ig << ' ' << ib << "\n"
    end
  end
end
