module Entities
  class Tree < Entity
    include Entities::Behaviours::Drawable
    include Entities::Behaviours::Blocking
    char 'T'
    colour Window::Colour::GREEN_ON_BLACK
  end
end
