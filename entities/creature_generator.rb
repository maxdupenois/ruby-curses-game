module Entities
  class CreatureGenerator < Entity
    include Entities::Behaviours::Commandable
    include Entities::Behaviours::Drawable
    include Entities::Behaviours::Blocking
    include Entities::Behaviours::LightSource
    char '~'
    light_radius 3
    max_brightness 5
    colour Window::Colour::BLUE
    allowed_commands :c
    ENTITY_TYPES = [Entities::Wolf, Entities::SmallMammal].freeze

    def c
      current_scene.status_message("Create Creature", colour: Window::Colour::BLUE)
      entity_type = ENTITY_TYPES.sample
      entity = entity_type.new(world)
      entity.x = x + rand(-5..5)
      entity.y = y + rand(-5..5)
      world.add_entity(entity)
    end
  end
end
