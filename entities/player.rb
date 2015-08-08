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

    def move(*args)
      moved = super(*args)
      if moved
        current_scene.status_message("Player moved to (#{x}, #{y})", colour: Window::Colour::BLUE)
      else
        current_scene.status_message("Blocked", colour: Window::Colour::RED)
      end
    end
  end
end
