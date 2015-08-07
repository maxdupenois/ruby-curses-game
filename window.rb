require 'curses'

class Window < Curses::Window
  class CannotBufferBufferedWindowError < StandardError; end

  attr_reader :x, :y, :height, :width, :parent_x, :parent_y

  def initialize(width: nil, height: nil,
                 # Potentially confusing naming here
                 x: 0, y: 0, is_buffer_window: false)
    self.class.start_if_not_running
    @x = 0
    @y = 0
    @parent_x = x
    @parent_y = y
    @width = width || self.class.width
    @height = height || self.class.height
    @primary_is_visible = true
    @is_buffer_window = is_buffer_window
    super(@height, @width, y, x)
    keypad(true)
  end

  def buffer_window?
    @is_buffer_window
  end

  def primary_is_visible?
    @primary_is_visible
  end

  def empty
    clear
  end

  def show
    move(parent_y, parent_x)
  end

  def hide
    move(self.class.height + 1, self.class.width + 1)
  end


#  def buffer(&block)
#    raise CannotBufferBufferedWindowError.new('Buffered windows can not be used as the primary from which to buffer') if buffer_window?
#    if primary_is_visible?
#      buffer_window.empty
#      block.call(buffer_window)
#      #Show is enough to make it the only visible window
#      buffer_window.show
#      @primary_is_visible = false
#    else
#      empty
#      block.call(self)
#      show
#      @primary_is_visible = true
#    end
#  end

  def centre
    move_to(width/2, height/2)
  end

  def move_by(by_x, by_y)
    move_to(x + by_x, y + by_y)
  end

  def move_to(x, y)
    @x = x
    @y = y
    setpos(y, x)
  end

  def draw(str, x=nil, y=nil)
    move_to(x, y) if x
    addstr(str)
  end

#  def status(message)
#    orig_x = x
#    orig_y = y
#    move_to(width - message.length - 1, 1)
#    draw(message)
#    move_to(orig_x, orig_y)
#  end

  class << self
    include Curses

    def gets
      getch
    end

    def width
      cols
    end

    def height
      lines
    end

    def start_if_not_running
      start unless running?
    end

    def running?
      @running
    end

    def refresh
      refresh
    end

    def start
      crmode
      curs_set(0)
      noecho
      timeout = 0
      stdscr.keypad = true
      @running = true
    rescue => e
      puts e.message
      finish
    end

    def finish
      @running = false
      close_screen
    end
  end

  private

  def buffer_window
    @buffer_window ||= self.class.new(width: width,
                   height: height,
                   x: parent_x,
                   y: parent_y,
                   is_buffer_window: true
                  )#.tap { |win| win.attron(Curses::A_INVIS) }
  end
end
