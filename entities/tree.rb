module Entities
  class Tree < Entity
    include Entities::Behaviours::Drawable
    include Entities::Behaviours::Blocking
    char 'T'
  end
end
