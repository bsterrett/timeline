class GameEvent < ActiveRecord::Base
  belongs_to :game_event_list
  belongs_to :player
  belongs_to :player_action

  def causal?
    !!causal
  end

  def acausal?
    !causal?
  end
end
