module Entities
  class Entity
    attr_accessor :x, :y
    attr_reader :world
    def initialize(world)
      @world = world
    end

    # manhattan
    def distance(entity)
      (entity.x - x) + (entity.y - y).abs
    end

    def current_scene
      Game.current.current_scene
    end

    BEHAVIOURS = %i[moveable commandable
                    light_source
                    drawable blocking
                    affected_by_time].freeze
    BEHAVIOURS.each do |behaviour|
      define_method("#{behaviour}?") { false }
    end
  end
end
require_relative "./entities/behaviour"
require_relative "./entities/player"
require_relative "./entities/tree"
require_relative "./entities/small_mammal"
require_relative "./entities/wolf"
