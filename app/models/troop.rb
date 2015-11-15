class Troop < ActiveRecord::Base
  belongs_to :player
  belongs_to :troop_type

  scope :living, -> { where('health > 0.0') }

  VALID_TARGETS = [Base]

  def attack_best_target targets
    attack_first_target in_range(targets) unless dead?
  end

  def attack_first_target targets
    target = targets.select do |target|
      target.living? and can_attack? target
    end.first

    attack target unless dead? or target.nil?
  end

  def attack target
    target.receive_damage current_attack unless dead?
  end

  def receive_damage damage
    starting_health = self.health
    effective_damage = damage * (10.0 - current_defense) / 10.0
    self.health -= effective_damage
    self.health = 0.0 if self.health < 0.0
    self.save
    starting_health - self.health
  end

  def advance_location
    decrement!(:location) unless dead? or self.location == 0
  end

  def current_defense
    troop_type.base_defense + level
  end

  def current_attack
    (troop_type.base_attack + level)/8.0
  end

  def current_range
    troop_type.base_range
  end

  def in_range targets
    targets.select { |target| (target.location - self.location).abs <= current_range }
  end

  def living?
    self.health > 0.0
  end

  def dead?
    !living?
  end

  def can_attack? target
    VALID_TARGETS.include? target.class
  end
end
