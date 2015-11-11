class AddRequireAdvanceGameVersionToGame < ActiveRecord::Migration
  def change
    add_column :games, :require_advance_game_version, :boolean, default: 0, null: false
  end
end
