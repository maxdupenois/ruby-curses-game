module Entities::Behaviours
  module AffectedByTime
    def time_advance(milliseconds)
      # override
    end

    def affected_by_time?
      true
    end
  end
end
