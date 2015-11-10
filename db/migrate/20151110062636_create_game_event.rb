class CreateGameEvent < ActiveRecord::Migration
  def change
    create_table :game_events do |t|
      t.references :game_event_list, index: true, foreign_key: true
      t.references :player, index: true, foreign_key: true
      t.boolean :causal, null: false, default: true
      t.integer :slice, null: false, limit: 8
      t.integer :acausal_target_slice, default: nil, limit: 8
    end
  end
end
