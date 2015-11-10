class CreateTroops < ActiveRecord::Migration
  def change
    create_table :troops do |t|
      t.references :player, index: true, foreign_key: true
      t.integer :position, null: false
      t.decimal :health, precision: 11, scale: 10, default: 1.0, null: false
      t.integer :level, default: 0, null: false
    end
  end
end
