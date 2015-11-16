class Tower < ActiveRecord::Base
  include ImmobileGamePiece
  include AttackingGamePiece
  include AttackableGamePiece

  belongs_to :player
  belongs_to :tower_type

  scope :living, -> { where('health > 0.0') }

  VALID_TARGETS = [Troop]

  def current_defense
    tower_type.base_defense + level
  end

  def current_attack
    (tower_type.base_attack + level)/2.0
  end

  def current_range
    ((level + tower_type.base_range) * 1.5).ceil
  end
end
