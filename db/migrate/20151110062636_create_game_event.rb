class CreateGameEvent < ActiveRecord::Migration
  def change
    create_table :game_events do |t|
      t.references :game_event_list, index: true, foreign_key: true
      t.references :player, index: true, foreign_key: true
      t.boolean :causal, null: false, default: true
      t.integer :frame, null: false, limit: 8, index: true
      t.integer :acausal_target_frame, default: nil, limit: 8

      t.timestamps null: false
    end
  end
end
