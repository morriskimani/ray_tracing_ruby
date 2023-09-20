require_relative './vec3'
require_relative './color'
require_relative './ray'

extend VectorUtils

# Determines whether a ray hits a given sphere (described by its center and radius)
#
# @param [Point3] center
# @param [Numeric] radius
# @param [Ray] ray
def hit_spere?(center, radius, ray)
  oc = ray.origin - center
  a = dot(ray.direction, ray.direction)
  b = 2.0 * dot(oc, ray.direction)
  c = dot(oc, oc) - radius * radius
  discriminant = b * b - 4 * a * c

  discriminant >= 0
end

def ray_color(ray)
  sphere_center = Point3.new(0, 0, -1)
  return Color.new(1, 0, 0) if hit_spere?(sphere_center, 0.5, ray)

  unit_direction = unit_vector(ray.direction)

  # Calculate the alpha value "a" to be used in linear interpolation: (1-a) 𝚡 start + a 𝚡 end
  # 0 <= a <= 1
  a = 0.5 * (unit_direction.y + 1)
  Color.new(1, 1, 1) * (1 - a) + Color.new(0.5, 0.7, 1.0) * a
end

# Image
aspect_ratio = 16.0 / 9.0
image_width = 400
image_height = (image_width / aspect_ratio).to_i
image_height = image_height < 1 ? 1 : image_height

# Camera
focal_length = 1.0
viewport_height = 2.0
# Note we are not using the aspect ratio value directly,
# because the actual aspect ratio of the image may be slightly different.
viewport_width = viewport_height * image_width.to_f / image_height
camera_center = Point3.new(0, 0, 0)

# Vectors across the horizontal (v) and down (v) the vertical viewport edges
viewport_u = Vec3.new(viewport_width, 0, 0)
viewport_v = Vec3.new(0, -viewport_height, 0)

# Pixel delta vectors from pixel to pixel. Vertical and Horizontal
pixel_delta_u = viewport_u / image_width
pixel_delta_v = viewport_v / image_height

viewport_upper_left = camera_center - Vec3.new(0, 0, focal_length) - viewport_u / 2 - viewport_v / 2
pixel00_loc = viewport_upper_left + (pixel_delta_u + pixel_delta_v) * 0.5

outfile = !ARGV.empty? ? "./output/#{ARGV.shift}.ppm" : './output/image.ppm'

# Render
File.open(outfile, 'w') do |file|
  file << "P3\n" << image_width << ' ' << image_height << "\n255\n"

  (0...image_height).each do |row|
    print("\rScanlines remaining:  #{image_height - 1} ")

    (0...image_width).each do |col|
      pixel_center = pixel00_loc + (pixel_delta_u * col) + (pixel_delta_v * row)
      ray_direction = pixel_center - camera_center
      ray = Ray.new(camera_center, ray_direction)

      pixel_color = ray_color(ray)
      ColorUtils.write_color(file, pixel_color)
    end
  end
  puts "\nImage saved as: #{outfile}"
end
