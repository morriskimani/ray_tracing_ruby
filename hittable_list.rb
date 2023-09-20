require_relative './hittable'
require_relative './interval'

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
      hit_record.copy_state_from(temp_rec)
    end

    hit_anything
  end
end
