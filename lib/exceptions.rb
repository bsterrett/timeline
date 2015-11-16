module Exceptions
  class TimelineError < StandardError; end
  class NoAvailableSpawnError < TimelineError; end
  class InsufficientResourcesError < TimelineError; end

  class GamePieceError < TimelineError; end
  class ImmobilePieceError < GamePieceError; end
end