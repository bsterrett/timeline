module AttackableGamePiece
  include GamePiece

  def receive_damage damage
    starting_health = self.health
    effective_damage = damage * (10.0 - self.current_defense) / 10.0
    self.health -= effective_damage
    self.health = 0.0 if self.health < 0.0
    self.save
    starting_health - self.health
  end
end
