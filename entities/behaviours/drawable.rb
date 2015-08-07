module Entities::Behaviours
  module Drawable
    class << self
      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods
      def char(char=nil)
        @char ||= '?'
        @char = char if char
        @char
      end

      def draw_priority(priority=nil)
        @draw_priority ||= 1
        @draw_priority = priority if priority
        @draw_priority
      end
    end

    def char
      self.class.char
    end

    def print(output)
      output << char
    end

    def draw_priority
      self.class.draw_priority
    end

    def drawable?
      true
    end
  end
end
