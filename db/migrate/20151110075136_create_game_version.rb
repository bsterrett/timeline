class CreateGameVersion < ActiveRecord::Migration
  def change
    create_table :game_versions do |t|
      t.references :game, index: true, foreign_key: true
      t.integer :version, index: true, null: false
      t.integer :starting_frame, null: false, limit: 8
      t.integer :current_frame, null: false, limit: 8

      t.timestamps null: false
    end
  end
end
