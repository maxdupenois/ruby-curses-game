module Entities
  class Player < Entity
    include Entities::Behaviours::Moveable
    include Entities::Behaviours::Commandable
    include Entities::Behaviours::Drawable
    include Entities::Behaviours::Blocking
    char '@'
    colour Window::Colour::RED_ON_BLACK
    allowed_commands :up, :down, :left, :right
  end
end
