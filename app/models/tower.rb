class Tower < ActiveRecord::Base
  belongs_to :player
  belongs_to :tower_type

  scope :living, -> { where('health > 0.0') }

  VALID_TARGETS = [Troop]

  def attack_best_target targets
    attack_first_target in_range(targets)
  end

  def attack_first_target targets
    target = targets.select do |target|
      target.living? and VALID_TARGETS.include? target.class
    end.first

    attack target unless target.nil?
  end

  def attack target
    target.send(:receive_damage, current_attack/2.0)
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

  def current_attack
    level + 1
  end

  def current_range
    ((level + 1) * 1.5).ceil
  end

  def in_range(targets)
    targets.select { |target| (target.location - self.location).abs <= current_range }
  end

  def living?
    self.health > 0.0
  end
end
