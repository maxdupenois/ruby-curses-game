module Entities::Behaviours
  module Moveable
    def right(amount = 1)
      move(amount, 0)
    end

    def left(amount = 1)
      move(-amount, 0)
    end

    def down(amount = 1)
      move(0, amount)
    end

    def up(amount = 1)
      move(0, -amount)
    end

    def move(mv_x, mv_y)
      world.move(self, x + mv_x, y + mv_y)
    end

    def moveable?
      true
    end
  end
end
