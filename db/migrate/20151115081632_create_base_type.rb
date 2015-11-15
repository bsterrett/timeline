class CreateBaseType < ActiveRecord::Migration
  def change
    create_table :base_types do |t|
      t.string :name, null: false
      t.string :display_name, null: false
      t.integer :base_attack, null: false
      t.integer :base_defense, null: false
      t.integer :base_range, null: false
      t.integer :base_speed, null: false
    end
  end
end
