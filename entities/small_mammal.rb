module Entities
  class SmallMammal < Entity
    include Entities::Behaviours::Moveable
    include Entities::Behaviours::Drawable
    include Entities::Behaviours::AffectedByTime
    char 'm'
    colour Window::Colour::YELLOW

    MS_BETWEEN_EACH_MOVE = 200

    def time_advance(ms)
      if can_move?(ms)
        predator = find_close_predator.first
        predator ? move_away(predator.x, predator.y) : wander
        @ms_since_last_move = 0
        wander
      else
        @ms_since_last_move += ms
      end
    end

    def find_close_predator
      world.entities_within_range(self, 4).select do |e|
        e.class == Entities::Wolf
      end.sort_by { |p| distance(p) }
    end

    def can_move?(ms)
      @ms_since_last_move ||= 0
      @ms_since_last_move >= MS_BETWEEN_EACH_MOVE
    end
  end
end
