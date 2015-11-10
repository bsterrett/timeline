class PlayerAction < ActiveRecord::Base
  belongs_to :player
  belongs_to :player_action_type

  has_one :actionable
end