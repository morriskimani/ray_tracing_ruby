class PpmFile
  def initialize(width, height, name = nil)
    @width = width
    @height = height
    @name = (name && ensure_extension(name)) || 'image.ppm'
    @default_path = './output'
  end

  def save(&render_block)
    File.open(file_name, 'w') do |file|
      file << "P3\n" << @width << ' ' << @height << "\n255\n"
      render_block.call(file)
    end
  end

  def file_name
    @file_name ||= "#{@default_path}/#{@name}"
  end

  private

  def ensure_extension(name)
    name.end_with?('ppm') ? name : "#{name}.ppm"
  end
end
