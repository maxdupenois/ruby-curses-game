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

  def draw(str, x=nil, y=nil, attrs: [], colour: nil)
    move_to(x, y) if x
    attrs << Window.colour_pair(colour) if colour
    attrs = attrs.reduce(attrs.shift) { |xor, attr| xor ^ attr}
    attron(attrs) if attrs
    addstr(str)
    attroff(attrs) if attrs
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
      init_colour_pairs!
      @running = true
    rescue => e
      puts e.message
      finish
    end

    def finish
      @running = false
      close_screen
    end

    def colour_pair(num)
      color_pair(num)
    end

    private

    def init_colour_pairs!
      start_color
      init_pair(Colour::RED_ON_BLACK, COLOR_RED, COLOR_BLACK)
      init_pair(Colour::GREEN_ON_BLACK, COLOR_GREEN, COLOR_BLACK)
      init_pair(Colour::YELLOW_ON_BLACK, COLOR_YELLOW, COLOR_BLACK)
      init_pair(Colour::BLUE_ON_BLACK, COLOR_BLUE, COLOR_BLACK)
      init_pair(Colour::CYAN_ON_BLACK, COLOR_CYAN, COLOR_BLACK)
      init_pair(Colour::MAGENTA_ON_BLACK, COLOR_MAGENTA, COLOR_BLACK)
      init_pair(Colour::WHITE_ON_BLACK, COLOR_WHITE, COLOR_BLACK)
    end
  end

  class Colour
    DEFAULT = 0
    RED_ON_BLACK = 1
    GREEN_ON_BLACK = 2
    YELLOW_ON_BLACK = 3
    BLUE_ON_BLACK = 4
    CYAN_ON_BLACK = 5
    MAGENTA_ON_BLACK = 6
    WHITE_ON_BLACK = 7
  end

end
