module Entities
  class Player < Entity
    include Entities::Behaviours::Moveable
    include Entities::Behaviours::Commandable
    include Entities::Behaviours::Drawable
    char '@'
    allowed_commands :up, :down, :left, :right
  end
end
