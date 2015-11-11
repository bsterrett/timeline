class CreateBase < ActiveRecord::Migration
  def change
    create_table :bases do |t|
      t.references :player, index: true, foreign_key: true
      t.decimal :health, precision: 11, scale: 10, default: 1.0, null: false
      t.integer :location, null: false
      t.integer :position, null: false

      t.timestamps null: false
    end
  end
end
