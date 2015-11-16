module ImmobileGamePiece
  include GamePiece

  def advance_location
    raise Exceptions::ImmobilePieceError, "{self.class} cannot move"
  end
end