class Troop < ActiveRecord::Base
  include MobileGamePiece
  include AttackingGamePiece
  include AttackableGamePiece

  belongs_to :player
  belongs_to :troop_type

  scope :living, -> { where('health > 0.0') }

  VALID_TARGETS = [Base]

  def current_defense
    troop_type.base_defense + level
  end

  def current_attack
    (troop_type.base_attack + level)/8.0
  end

  def current_range
    troop_type.base_range
  end
end
