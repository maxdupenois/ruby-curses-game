module Entities::Behaviours
  module LightSource
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def light_radius(radius=nil)
        @light_radius ||= 1
        @light_radius = radius if radius
        @light_radius
      end
      def max_brightness(max_brightness=nil)
        @max_brightness ||= 2
        @max_brightness = max_brightness if max_brightness
        @max_brightness
      end
    end

    def max_brightness
      self.class.max_brightness
    end

    def light_radius
      self.class.light_radius
    end

    def light_source?
      true
    end
  end
end
