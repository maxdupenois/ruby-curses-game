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

    def wander
      move_x = rand(2) == 1
      x = move_x ? rand(3) - 1 : 0
      y = move_x ? 0 : rand(3) - 1
      move(x, y)
    end

    def move_away(dest_x, dest_y)
      dist_x = (x - dest_x)
      dist_y = (y - dest_y)
      if dist_x.abs > dist_y.abs
        move(0, dist_y > 0 ? 1 : -1)
      else
        move(dist_x > 0 ? 1 : -1, 0)
      end
    end

    def move_toward(dest_x, dest_y)
      dist_x = (x - dest_x)
      dist_y = (y - dest_y)
      return if dist_x == 0 && dist_y == 0
      if dist_x.abs > dist_y.abs
        move(dist_x > 0 ? -1 : 1, 0)
      else
        move(0, dist_y > 0 ? -1 : 1)
      end
    end

    def moveable?
      true
    end
  end
end
