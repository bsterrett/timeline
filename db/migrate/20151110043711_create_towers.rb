class CreateTowers < ActiveRecord::Migration
  def change
    create_table :towers do |t|
      t.references :player, index: true, foreign_key: true
      t.references :tower_type, index: true, foreign_key: true
      t.integer :level, null: false, default: 0
      t.integer :location, null: false
      t.integer :position, null: false

      t.timestamps null: false
    end
  end
end
