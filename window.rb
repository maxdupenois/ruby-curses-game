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

  def draw(str, x=nil, y=nil, attrs: [], colour: nil, brightness: 1)
    move_to(x, y) if x
    if str.nil?
      attrs << Window.background_colour_pair(brightness: brightness)
      str = 'b'
    elsif colour
      attrs << Window.colour_pair(colour.index, brightness: brightness)
    end
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
      finish
      puts colors
      puts e.message
      puts e.backtrace[0..3]
    end

    def finish
      @running = false
      close_screen
    end

    def colour_pair(num, brightness:1)
      num = num + background_colour_count
      if brightness <= 0
        # dark
        color_pair(num)
      elsif brightness > 0 && brightness < 1
        # dim
        color_pair(num + 1)
      elsif brightness >= 1 && brightness < 2
        # normal
        color_pair(num + 2)
      else
        # bright
        color_pair(num + 3)
      end
    end

    def background_colour_pair(brightness: 0)
      if brightness <= 0
        color_pair(dark_background)
      elsif brightness > 0 && brightness < 1
        color_pair(dim_background)
      elsif brightness >= 1 && brightness < 2
        color_pair(normal_background)
      else
        color_pair(bright_background)
      end
    end


    private

    attr_reader :dark_background, :dim_background, :normal_background, :bright_background, :background_colour_count
    def init_colour_pairs!
      start_color

      init_color(0, 0, 0, 0)
      @dark_background = 1
      @dim_background = 2
      @normal_background = 3
      @bright_background = 4
      @background_colour_count = 4

      init_color(dark_background, 0, 0, 0)
      init_color(dim_background, 100, 100, 100)
      init_color(normal_background, 100, 100, 100)
      init_color(bright_background, 250, 250, 250)
      init_pair(dark_background, dark_background, dark_background)
      init_pair(dim_background, dim_background, dim_background)
      init_pair(normal_background, normal_background, normal_background)
      init_pair(bright_background, bright_background, bright_background)
      Colour::COLOURS.each do |colour|
        i = colour.index + background_colour_count
        init_color(i, *colour.dark)
        init_color(i + 1, *colour.dim)
        init_color(i + 2, *colour.normal)
        init_color(i + 3, *colour.bright)
        init_pair(i, i, dark_background) 
        init_pair(i + 1, i + 1, dim_background)
        init_pair(i + 2, i + 2, normal_background)
        init_pair(i + 3, i + 3, bright_background)
      end

      #init_pair(Colour::RED_ON_BLACK, COLOR_RED, COLOR_BLACK)
      #init_pair(Colour::GREEN_ON_BLACK, COLOR_GREEN, COLOR_BLACK)
      #init_pair(Colour::YELLOW_ON_BLACK, COLOR_YELLOW, COLOR_BLACK)
      #init_pair(Colour::BLUE_ON_BLACK, COLOR_BLUE, COLOR_BLACK)
      #init_pair(Colour::CYAN_ON_BLACK, COLOR_CYAN, COLOR_BLACK)
      #init_pair(Colour::MAGENTA_ON_BLACK, COLOR_MAGENTA, COLOR_BLACK)
      #init_pair(Colour::WHITE_ON_BLACK, COLOR_WHITE, COLOR_BLACK)
    end
  end

  class Colour
    attr_writer :dark, :dim, :bright
    attr_reader :index, :normal
    class << self
      def new_index
        @index ||= 1
        new_i = @index
        @index += 4
        new_i
      end
    end

    def initialize(r, g, b)
      @normal = [r, g, b]
      @index = self.class.new_index
    end

    def bright
      @bright ||= normal.map {|c| [1000, (c * 1.2)].min.round.to_i }
    end

    def dim
      @dim ||= normal.map {|c| (c/2.0).round.to_i }
    end

    def dark
      @dark ||= normal.map {|c| (c/4.0).round.to_i }
    end

    RED = Colour.new(750, 0, 0)
    GREEN = Colour.new(0, 750, 0)
    YELLOW = Colour.new(900, 900, 0)
    BLUE = Colour.new(0, 0, 750)
    CYAN = Colour.new(0, 900, 900)
    MAGENTA = Colour.new(900, 0, 900)
    WHITE = Colour.new(900, 900, 900)
    #GREY = Colour.new(250, 250, 250)
    DEFAULT = WHITE
    COLOURS = [RED, GREEN, YELLOW,
               BLUE, CYAN, MAGENTA,
               WHITE]
  end

end
