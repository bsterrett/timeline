class AddGameStatusToGame < ActiveRecord::Migration
  def change
    add_reference :games, :game_status, index: true
    add_foreign_key :games, :game_statuses
  end
end
