module Entities
  class SmallMammal < Entity
    include Entities::Behaviours::Moveable
    include Entities::Behaviours::Drawable
    include Entities::Behaviours::AffectedByTime
    char 'm'
    colour Window::Colour::YELLOW_ON_BLACK

    MS_BETWEEN_EACH_MOVE = 500

    def time_advance(ms)
      move_x = rand(2) == 1
      x = move_x ? rand(3) - 1 : 0
      y = move_x ? 0 : rand(3) - 1
      if can_move?(ms)
        @ms_since_last_move = 0
        move(x, y)
      else
        @ms_since_last_move += ms
      end
    end

    def can_move?(ms)
      @ms_since_last_move ||= 0
      @ms_since_last_move >= MS_BETWEEN_EACH_MOVE
    end
  end
end
