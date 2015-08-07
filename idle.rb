require_relative './game'
require_relative './idle_game_scene'
class Idle < Game
  def setup
    scenes << IdleGameScene.new(self)
  end
end
