module Exceptions
  class TimelineError < StandardError; end
  class NoAvailableSpawnError < TimelineError; end
  class InsufficientResourcesError < TimelineError; end
end