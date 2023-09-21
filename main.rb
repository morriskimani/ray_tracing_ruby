require_relative './vec3'
require_relative './hittable_list'
require_relative './sphere'
require_relative './camera'

world = HittableList.new
world << Sphere.new(Point3.new(0, 0, -1), 0.5)
world << Sphere.new(Point3.new(0, -100.5, -1), 100)

camera = Camera.new
camera.aspect_ratio = 16.0 / 9.0
camera.image_width = 400
camera.samples_per_pixel = 100
camera.max_depth = 50

camera.render(world)
