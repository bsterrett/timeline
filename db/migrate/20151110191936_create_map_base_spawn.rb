class CreateMapBaseSpawn < ActiveRecord::Migration
  def change
    create_table :map_base_spawns do |t|
      t.references :map, index: true, foreign_key: true
      t.integer :location, null: false
      t.integer :position, null: false

      t.timestamps null: false
    end
  end
end
