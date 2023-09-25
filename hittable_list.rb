require_relative './hittable'
require_relative './interval'

# A list of hittable objects
class HittableList < Hittable
  def initialize(object = nil) # rubocop:disable Lint/MissingSuper
    @objects = object ? [object] : []
  end

  def <<(object)
    @objects << object
  end

  def clear
    @objects = []
  end

  def hit(ray, ray_t, hit_record)
    temp_rec = HitRecord.new
    hit_anything = false
    closest_so_far = ray_t.max

    @objects.each do |obj|
      next unless obj.hit(ray, Interval.new(ray_t.min, closest_so_far), temp_rec)

      hit_anything = true
      closest_so_far = temp_rec.t

      # TODO: this looks like a dirty hack.
      # only doing this to match the C++ tutorial where they pass in a pointer.
      # Rather than pass in a HitRecord whose state we modify,
      # Can we have the #hit method return a HitRecord if there was a hit?
      hit_record.copy_state_from(temp_rec)
    end

    hit_anything
  end
end
