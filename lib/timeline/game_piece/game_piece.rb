module GamePiece
  def living?
    self.health > 0.0
  end

  def dead?
    !living?
  end
end
