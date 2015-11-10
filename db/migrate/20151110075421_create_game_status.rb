class CreateGameStatus < ActiveRecord::Migration
  def change
    create_table :game_statuses do |t|
      t.string :name, null: false
      t.string :display_name, null: false
    end
  end
end
