require_relative './vec3'
require_relative './hittable_list'
require_relative './sphere'
require_relative './camera'
require_relative './material'

material_ground = Lambertian.new(Color.new(0.8, 0.8, 0))
material_center = Dielectric.new(1.5)
material_left = Dielectric.new(1.5)
material_right = Metal.new(Color.new(0.8, 0.6, 0.2), 1.0)

world = HittableList.new
world << Sphere.new(Point3.new(0, -100.5, -1), 100, material_ground)
world << Sphere.new(Point3.new(0, 0, -1), 0.5, material_center)
world << Sphere.new(Point3.new(-1, 0, -1), 0.5, material_left)
world << Sphere.new(Point3.new(1, 0, -1), 0.5, material_right)

camera = Camera.new
camera.aspect_ratio = 16.0 / 9.0
camera.image_width = 400
camera.samples_per_pixel = 100
camera.max_depth = 50

camera.render(world)
