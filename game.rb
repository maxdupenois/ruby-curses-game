require './command_receiver'

class Game
  DESIRED_GLPS = 50
  REQUIRED_MS_PER_GL = 1000/DESIRED_GLPS.to_f
  attr_reader :game_world, :command_receiver, :window, :error

  def initialize
    Game.current = self
  end

  class << self
    attr_accessor :current
  end

  def scenes
    @scenes ||= []
  end

  def current_scene
    @current_scene ||= scenes.first
  end

  def change_scene(to)
    to.prepare_scene
    old = current_scene
    @current_scene = to
    old.cleanup
  end

  def start
    @finished = false
    @error = nil
    @command_receiver = CommandReceiver.new
    setup
    current_scene.prepare_scene
    run!
  end

  def setup
    raise NoMethodError.new('Should be overridden')
  end

  private

  def run_command_receiver!
    while !finished?
      command = command_receiver.receive
      finish! if command.quit?
      current_scene.command_received(command)
    end
  end

  def run!
    Thread.new do
      last_time_advance = Time.now.to_f
      while !finished?
        difference  = in_ms(Time.now.to_f - last_time_advance)
        sleep_ms = game_loop do
          current_scene.time_advance(difference)
          current_scene.draw
        end
        last_time_advance = Time.now.to_f
        sleep(sleep_ms / 1000.to_f)
      end
    end
    run_command_receiver!
  end

  def in_ms(float_time)
    (float_time * 1000)
  end

  def game_loop
    time_start = Time.now.to_f
    begin
      yield
    rescue => e
      @error = e
      finish!
    end
    time_taken_ms = in_ms(Time.now.to_f - time_start)
    [REQUIRED_MS_PER_GL - time_taken_ms, 0].max
  end

  def finished?
    @finished
  end

  def finish!
    Window.finish #close any open screens
    @finished = true
    if error
      puts error.message
      puts error.backtrace[0..5]
    end
  end
end
