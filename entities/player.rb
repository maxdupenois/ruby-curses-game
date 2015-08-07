module Entities
  class Player < Entity
    include Entities::Behaviours::Moveable
    include Entities::Behaviours::Commandable
    include Entities::Behaviours::Drawable
    include Entities::Behaviours::Blocking
    char '@'
    colour Window::Colour::RED_ON_BLACK
    allowed_commands :up, :down, :left, :right

    def move(*args)
      moved = super(*args)
      if moved
        current_scene.status_message("Player moved to (#{x}, #{y})", colour: Window::Colour::CYAN_ON_BLACK)
      else
        current_scene.status_message("Blocked", colour: Window::Colour::RED_ON_BLACK)
      end
    end
  end
end
