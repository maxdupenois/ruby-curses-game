module Entities
  class Player < Entity
    include Entities::Behaviours::Moveable
    include Entities::Behaviours::Commandable
    include Entities::Behaviours::Drawable
    include Entities::Behaviours::Blocking
    include Entities::Behaviours::LightSource
    char '@'
    light_radius 10
    max_brightness 5
    colour Window::Colour::WHITE
    allowed_commands :up, :down, :left, :right

    def max_brightness
      original = super
      flicker('light_brightness', 3, 10)
    end

    def light_radius
      original = super
      flicker('light_radius', 3, 8)
    end

    def flicker(key, min, max)
      @last_flicker ||= Hash.new
      last = @last_flicker.fetch(key, Time.now.to_f - 2)
      now = Time.now.to_f
      if now - last >= 0.3
        @last_flicker[key] = now
        min + rand(max - min)
      else
        ((min + max) / 2).round.to_i
      end
    end

    def move(*args)
      moved = super(*args)
      unless moved
        current_scene.status_message("Blocked", colour: Window::Colour::RED)
      end
    end
  end
end
