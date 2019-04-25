module Entities::Behaviours
  module Commandable
    class << self
      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods
      def allowed_commands(*cmds)
        @allowed_commands ||= []
        @allowed_commands += cmds if cmds.any?
        @allowed_commands
      end
    end

    def command(command)
      return unless self.class.allowed_commands.include?(command.message)

      public_send(command.message)
    rescue StandardError => e
      puts "#{e.class} #{e.message}"
    end

    def commandable?
      true
    end
  end
end
