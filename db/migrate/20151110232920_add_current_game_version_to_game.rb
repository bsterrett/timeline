class AddCurrentGameVersionToGame < ActiveRecord::Migration
  def change
    add_column :games, :current_game_version_id, :integer
    add_index :games, :current_game_version_id
    add_foreign_key :games, :game_versions, column: :current_game_version_id
  end
end
