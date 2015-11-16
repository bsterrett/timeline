module InvulnerableGamePiece
  include GamePiece

  def receive_damage damage
    raise Exceptions::InvulnerablePieceError, "{self.class} cannot receive damage"
  end
end