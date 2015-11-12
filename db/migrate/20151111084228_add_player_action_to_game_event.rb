class AddPlayerActionToGameEvent < ActiveRecord::Migration
  def change
    add_reference :game_events, :player_action, index: true
    add_foreign_key :game_events, :player_actions
  end
end
