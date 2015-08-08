require_relative './window'

class GameWorld

  attr_reader :map, :height, :width, :entities

  def initialize(height:, width:)
    @height = height
    @width = width
    @entities = []
    @map = Array.new(height){ Array.new(width) {[]} }
  end

  def add_entity(entity, x: entity.x, y: entity.y)
    x ||= 0
    y ||= 0
    return false unless can_place_entity?(entity, x, y)
    map_put(x, y, entity)
    entities << entity
  end

  def time_advance(milliseconds)
    affected_by_time = entities.select { |e| e.affected_by_time? }
    affected_by_time.each { |e| e.time_advance(milliseconds) }
  end

  def command_received(command)
    commandable = entities.select { |e| e.commandable? }
    commandable.each { |e| e.command(command) }
  end

  def draw(window)
    lighting_map = generate_lighting_map
    height.times do |y| 
      width.times do |x| 
        entities = map_get(x, y).select { |e| e.drawable? }
        if entities.empty?
          window.draw(' ', x+1, y+1)
          next
        end
        brightness = lighting_map[x][y]
        entity = entities.sort_by { |e| e.draw_priority }.first
        window.draw(entity.char, x+1, y+1,
                    colour: entity.colour, brightness: brightness)
        occasional_status("Tree Brightness: #{brightness}") if entity.class == Entities::Tree
      end
    end
  end

  # Used when debugging draw method
  def occasional_status(message)
    @last_printed_occasional_status ||= Time.now.to_i - 5
    now = Time.now.to_i
    if now - @last_printed_occasional_status > 2
      status_message(message)
      @last_printed_occasional_status = Time.now.to_i
    end
  end

  def generate_lighting_map
    light_sources = entities.select { |e| e.light_source? }
    lighting_map = Array.new(height) { Array.new(width) { 0 } }
    light_sources.each do |source|
      radar(source.x, source.y, source.light_radius) do |x, y, rad|
        brightness = source.max_brightness / rad.to_f
        lighting_map[x][y] += brightness
      end
      lighting_map[source.x][source.y] += source.max_brightness
    end
    lighting_map
  end

  def move(entity, x, y)
    return false unless can_place_entity?(entity, x, y)
    map_remove(entity.x, entity.y, entity)
    map_put(x, y, entity)
    true
  end

  def entities_within_range(entity, range)
    entities = []
    radar(entity.x, entity.y, range) do |x, y|
      entities += map_get(x, y)
    end
    entities
  end

  def status_message(msg)
    Game.current.current_scene.status_message(msg.to_s)
  end

  def radar(x, y, radius, &block)
    origin_x = x
    origin_y = y
    while(radius > 0)
      stack = []
      north = [origin_x, origin_y - radius]
      east = [origin_x + radius, origin_y]
      south = [origin_x, origin_y + radius]
      west = [origin_x - radius, origin_y]
      current = north.dup
      #traverse north to east
      while(current != east)
        block.call(*current, radius) if on_map?(*current)
        current[0] += 1
        current[1] += 1
      end

      ##traverse east to south
      while(current != south)
        block.call(*current, radius) if on_map?(*current)
        current[0] += -1
        current[1] += 1
      end

      ##traverse south to west
      while(current != west)
        block.call(*current, radius) if on_map?(*current)
        current[0] += -1
        current[1] += -1
      end

      ##traverse west to north
      while(current != north)
        block.call(*current, radius) if on_map?(*current)
        current[0] += 1
        current[1] += -1
      end
      radius -= 1
    end
  end

  private

  def can_place_entity?(entity, x, y)
    return false unless on_map?(x, y)
    currently_there = map_get(x, y)
    return false if currently_there.any? { |e| e.blocking? }
    !(currently_there.any? && entity.blocking?)
  end

  def on_map?(x, y)
    x >= 0 && x < width && y >= 0 && y < height
  end

  def map_get(x, y)
    map[y][x]
  end

  def map_put(x, y, entity)
    map[y][x].push(entity)
    entity.x = x
    entity.y = y
  end

  def map_remove(x, y, entity)
    map[y][x].delete(entity)
    entity.x = nil
    entity.y = nil
  end
end
