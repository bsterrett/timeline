class Base < ActiveRecord::Base
  belongs_to :player

  scope :living, -> { where('health > 0.0') }

  def attack_best_target targets
  end

  def receive_damage damage
    effective_damage = damage * (10.0 - current_defense) / 10.0
    self.health -= effective_damage
    self.health = 0.0 if self.health < 0.0
    self.save
  end

  def current_defense
    level
  end
end
