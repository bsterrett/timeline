class Troop < ActiveRecord::Base
  belongs_to :player
  has_one :troop_type

  def attack_best_target targets
    # TODO: find a way to get the best target
    attack_first_target
  end

  def attack_first_target targets
    target = targets.first
    if target.is_a? Base or target.is_a? Tower
      attack target
    end
  end

  def attack target
    target.send(:receive_damage, current_attack)
  end

  def receive_damage damage
    effective_damage = damage * (10.0 - current_defense) / 10.0

    decrement!(:health, effective_damage)
  end

  def current_defense
    base_defense
  end

  def current_attack
    base_attack
  end
end
