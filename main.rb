require_relative './vec3'
require_relative './hittable_list'
require_relative './sphere'
require_relative './camera'
require_relative './material'

R = Math.cos(Math::PI / 4)

material_left = Lambertian.new(Color.new(0, 0, 1))
material_right = Lambertian.new(Color.new(1, 0, 0))

world = HittableList.new
world << Sphere.new(Point3.new(-R, 0, -1), R, material_left)
world << Sphere.new(Point3.new(R, 0, -1), R, material_right)

camera = Camera.new
camera.aspect_ratio = 16.0 / 9.0
camera.image_width = 400
camera.samples_per_pixel = 100
camera.max_depth = 50

camera.vertical_fov = 90

camera.render(world)
