class CreateGameEventList < ActiveRecord::Migration
  def change
    create_table :game_event_lists do |t|
      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
