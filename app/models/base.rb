class Base < ActiveRecord::Base
  include ImmobileGamePiece
  include AttackingGamePiece
  include AttackableGamePiece

  belongs_to :player
  belongs_to :base_type

  default_scope { includes(:base_type) }
  scope :living, -> { where('health > 0.0') }

  VALID_TARGETS = [Troop]

  def current_defense
    base_type.base_defense + level
  end

  def current_attack
    (base_type.base_attack + level)/1.5
  end

  def current_range
    level + base_type.base_range
  end
end
