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
    height.times do |y| 
      width.times do |x| 
        entities = map_get(x, y).select { |e| e.drawable? }
        if entities.empty?
          window.draw(' ', x+1, y+1)
          next
        end
        entity = entities.sort_by { |e| e.draw_priority }.first
        window.draw(entity.char, x+1, y+1)
      end
    end
    window.status(@status) if @status
  end

  def print_map
    buffer = []
    buffer << ('-' * (width + 2))
    buffer << "\n"
    height.times do |y| 
      buffer << '|'
      width.times do |x| 
        entities = map_get(x, y).select { |e| e.drawable? }
        buffer << " " and next if entities.empty?
        entity = entities.sort_by { |e| e.draw_priority }.first
        entity.print(buffer)
      end
      buffer << '|'
      buffer << "\n"
    end
    buffer << ('-' * (width + 2))
    puts buffer.join('')
    true
  end

  def move(entity, x, y)
    return [entity.x, entity.y] unless can_place_entity?(entity, x, y)
    map_remove(entity.x, entity.y, entity)
    map_put(x, y, entity)
  end

  private

  def can_place_entity?(entity, x, y)
    return false if x < 0 || x >= width || y < 0 || y >= height
    currently_there = map_get(x, y)
    return false if currently_there.any? { |e| e.blocking? }
    !(currently_there.any? && entity.blocking?)
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
