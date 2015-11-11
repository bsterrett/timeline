class Base < ActiveRecord::Base
  belongs_to :player

  def attack_best_target targets
  end

  def receive_damage damage
    effective_damage = damage * (10.0 - current_defense) / 10.0

    decrement!(:health, effective_damage)
  end

  def current_defense
    0
  end
end
