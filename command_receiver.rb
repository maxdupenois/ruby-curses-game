require 'curses'
class CommandReceiver
  class Command < Struct.new(:raw_command)
    MESSAGES = {
      Curses::Key::UP => :up,
      Curses::Key::DOWN => :down,
      Curses::Key::LEFT => :left,
      Curses::Key::RIGHT => :right
    }

    def quit?
      ['q', 'Q'].include?(char)
    end

    def message
      MESSAGES.fetch(code, char)
    end

    def code
      if raw_command.is_a?(Fixnum)
        raw_command.to_i
      else
        raw_command.ord
      end
    end

    def char
      raw_command.to_s
    end
  end

  def receive
    Command.new(Window.gets)
  end

end

