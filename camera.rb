require_relative './vec3'
require_relative './color'
require_relative './ray'
require_relative './ppm_file'
require_relative './material'

class Camera
  include VectorUtils

  def initialize
    @aspect_ratio = 16.0 / 9.0 # Ratio of image width to height
    @image_width = 400
    @samples_per_pixel = 10 # count of random samples for each pixel
    @max_depth = 10 # maximum number of ray bounces onto a scene
  end
  attr_accessor :aspect_ratio, :image_width, :samples_per_pixel, :max_depth

  def render(world)
    init

    image_file = PpmFile.new(@image_width, @image_height, ARGV.shift)
    image_file.save do |file|
      (0...@image_height).each do |row|
        print("\rScanlines remaining:  #{@image_height - row} ")

        (0...@image_width).each do |col|
          pixel_color = Color.new(0, 0, 0)
          @samples_per_pixel.times do
            ray = get_ray(row, col)
            pixel_color += ray_color(ray, @max_depth, world)
          end

          ColorUtils.write_color(file, pixel_color, @samples_per_pixel)
        end
      end
    end

    puts "\nImage saved as: #{image_file.file_name}"
  end

  private

  def init
    @image_height = (@image_width / @aspect_ratio).to_i
    @image_height = @image_height < 1 ? 1 : @image_height

    # Camera center
    @center = Point3.new(0, 0, 0)

    # Viewport Dimensions
    @focal_length = 1.0
    @viewport_height = 2.0
    # Note we are not using the @aspect_ratio value directly,
    # because the actual aspect ratio of the image may be slightly different.
    @viewport_width = @viewport_height * @image_width.to_f / @image_height

    # Vectors across the horizontal (v) and down (v) the vertical viewport edges
    @viewport_u = Vec3.new(@viewport_width, 0, 0)
    @viewport_v = Vec3.new(0, -@viewport_height, 0)

    # Pixel delta vectors from pixel to pixel. Vertical and Horizontal
    @pixel_delta_u = @viewport_u / @image_width
    @pixel_delta_v = @viewport_v / @image_height

    @viewport_upper_left = @center - Vec3.new(0, 0, @focal_length) - @viewport_u / 2 - @viewport_v / 2
    @pixel00_loc = @viewport_upper_left + (@pixel_delta_u + @pixel_delta_v) * 0.5
  end

  def ray_color(ray, depth, world)
    # Bounce limit exceeded. No more light is gathered
    return Color.new(0, 0, 0) if depth <= 0

    hit_record = HitRecord.new
    ray_t = Interval.new(0.001, Float::INFINITY)
    if world.hit(ray, ray_t, hit_record)
      scatter_rec = hit_record.material.scatter(ray, hit_record)
      return Color.new(0, 0, 0) unless scatter_rec.is_scattered

      return scatter_rec.attenuation * ray_color(scatter_rec.scattered_ray, depth - 1, world)
    end

    unit_direction = unit_vector(ray.direction)

    # Calculate the alpha value "a" to be used in linear interpolation: (1-a) 𝚡 start + a 𝚡 end
    # 0 <= a <= 1
    a = 0.5 * (unit_direction.y + 1)
    Color.new(1, 1, 1) * (1 - a) + Color.new(0.5, 0.7, 1.0) * a
  end

  def get_ray(row, col)
    pixel_center = @pixel00_loc + (@pixel_delta_u * col) + (@pixel_delta_v * row)
    pixel_sample = pixel_center + pixel_sample_square

    ray_origin = @center
    ray_direction = pixel_sample - ray_origin

    Ray.new(ray_origin, ray_direction)
  end

  def pixel_sample_square
    px = -0.5 + rand
    py = -0.5 + rand

    (@pixel_delta_u * px) + (@pixel_delta_v * py)
  end
end
