class Scene
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def command_received(command)
  end

  def prepare_scene
  end

  def time_advance(milliseconds)
  end

  def draw
  end
end
