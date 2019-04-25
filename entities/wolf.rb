module Entities
  class Wolf < Entity
    include Entities::Behaviours::Moveable
    include Entities::Behaviours::Drawable
    include Entities::Behaviours::AffectedByTime
    char "w"
    colour Window::Colour::MAGENTA

    MS_BETWEEN_EACH_MOVE = 400

    def time_advance(ms)
      if can_move?(ms)
        prey = find_close_prey.first
        prey ? move_toward(prey.x, prey.y) : wander
        @ms_since_last_move = 0
      else
        @ms_since_last_move += ms
      end
    end

    def wander
      move_x = rand(2) == 1
      x = move_x ? rand(-1..1) : 0
      y = move_x ? 0 : rand(-1..1)
      move(x, y)
    end

    def find_close_prey
      world.entities_within_range(self, 5).select{ |e|
        e.class == Entities::SmallMammal
      }.sort_by { |p| distance(p) }
    end

    def can_move?(_ms)
      @ms_since_last_move ||= 0
      @ms_since_last_move >= MS_BETWEEN_EACH_MOVE
    end
  end
end
