require_relative './game_world'
require_relative './scene'
require_relative './entity'
class IdleGameScene < Scene
  MAX_STATUS_LENGTH = 10
  attr_reader :game_world_window, :game_world, :status_window

  def prepare_scene
    Window.start_if_not_running
    game_world_height = (Window.height * 0.75).round.to_i
    status_height = Window.height - game_world_height

    @game_world_window = Window.new(
      x: 0, y: 0,
      width: Window.width,
      height: game_world_height)

    @status_window = Window.new(
      x: 0, y: game_world_height,
      width: Window.width,
      height: status_height)

    @game_world = GameWorld.new(
      # - 2 to allow for border
      width: game_world_window.width - 2,
      height: game_world_window.height - 2)
    load_entities!
  end

  def time_advance(milliseconds)
    game_world.time_advance(milliseconds)
  end

  def command_received(command)
    game_world.command_received(command)
  end

  def status_message(message, colour: Window::Colour::DEFAULT)
    status << [message, colour]
    status.shift if status.size > MAX_STATUS_LENGTH
  end

  def draw
    game_world_window.box(0, 0)
    status_window.box(0, 0)
    game_world.draw(game_world_window)
    game_world_window.refresh

    status.reverse.each_with_index do |(message, colour), y|
      status_window.draw(' ' * (Window.width - 3), 1, y + 1)
      status_window.draw(message, 3, y + 1, colour: colour)
    end

    status_window.refresh
  end

  def cleanup
    game_world_window.close
  end

  private

  def status
    @status ||= []
  end
  

  def load_entities!
    player = Entities::Player.new(game_world)
    player.x = 2
    player.y = 3
    tree = Entities::Tree.new(game_world)
    tree.x = 4
    tree.y = 4
    mammal = Entities::SmallMammal.new(game_world)
    mammal.x = 3
    mammal.y = 3
    wolf = Entities::Wolf.new(game_world)
    wolf.x = 6
    wolf.y = 6
    game_world.add_entity(player)
    game_world.add_entity(wolf)
    game_world.add_entity(mammal)
    game_world.add_entity(tree)
  end
end
