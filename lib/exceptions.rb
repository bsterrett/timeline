module Exceptions
  class TimelineError < StandardError; end

  class PlayerConstraintsError < TimelineError; end
  class NoAvailableSpawnError < PlayerConstraintsError; end
  class InsufficientResourcesError < PlayerConstraintsError; end

  class GamePieceError < TimelineError; end
  class ImmobilePieceError < GamePieceError; end
  class InvulnerablePieceError < GamePieceError; end
end