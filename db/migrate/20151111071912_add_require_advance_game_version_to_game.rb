class AddRequireAdvanceGameVersionToGame < ActiveRecord::Migration
  def change
    add_column :games, :require_advance_game_version, :boolean, default: false, null: false
  end
end
