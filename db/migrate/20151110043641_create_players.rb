class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :game, index: true, foreign_key: true
      t.integer :resources, :default => 1000, limit: 8, null: false
      t.string :name, :default => 'Player One', null: false

      t.timestamps null: false
    end
  end
end
