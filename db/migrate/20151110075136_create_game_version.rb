class CreateGameVersion < ActiveRecord::Migration
  def change
    create_table :game_versions do |t|
      t.references :game, index: true, foreign_key: true
      t.integer :number, index: true, null: false
      t.integer :starting_slice, null: false
    end
  end
end
