class CreateMap < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name, null: false
      t.string :display_name, null: false
      t.integer :max_players, null: false, default: 2
      t.integer :max_player_towers, null: false

      t.timestamps null: false
    end
  end
end
