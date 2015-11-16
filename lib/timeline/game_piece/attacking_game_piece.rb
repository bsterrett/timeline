module AttackingGamePiece
  include GamePiece

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
    target.receive_damage self.current_attack unless dead?
  end

  def can_attack? target
    self.class::VALID_TARGETS.include? target.class
  end

  def in_range targets
    targets.select { |target| (target.location - self.location).abs <= self.current_range }
  end
end
