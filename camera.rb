require_relative './vec3'
require_relative './color'
require_relative './ray'

class Camera
  include VectorUtils

  def initialize
    @aspect_ratio = 16.0 / 9.0
    @image_width = 400
  end
  attr_writer :aspect_ratio, :image_width

  def render(world)
    init

    File.open(outfile, 'w') do |file|
      file << "P3\n" << @image_width << ' ' << @image_height << "\n255\n"

      (0...@image_height).each do |row|
        print("\rScanlines remaining:  #{@image_height - row} ")

        (0...@image_width).each do |col|
          pixel_center = @pixel00_loc + (@pixel_delta_u * col) + (@pixel_delta_v * row)
          ray_direction = pixel_center - @center
          ray = Ray.new(@center, ray_direction)

          pixel_color = ray_color(ray, world)
          ColorUtils.write_color(file, pixel_color)
        end
      end
      puts "\nImage saved as: #{outfile}"
    end
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

  def ray_color(ray, world)
    hit_record = HitRecord.new
    ray_t = Interval.new(0, Float::INFINITY)
    if world.hit(ray, ray_t, hit_record) # rubocop:disable Style/IfUnlessModifier
      return (hit_record.normal + Color.new(1, 1, 1)) * 0.5
    end

    unit_direction = unit_vector(ray.direction)

    # Calculate the alpha value "a" to be used in linear interpolation: (1-a) 𝚡 start + a 𝚡 end
    # 0 <= a <= 1
    a = 0.5 * (unit_direction.y + 1)
    Color.new(1, 1, 1) * (1 - a) + Color.new(0.5, 0.7, 1.0) * a
  end

  def outfile
    @outfile ||= !ARGV.empty? ? "./output/#{ARGV.shift}.ppm" : './output/image.ppm'
  end
end
