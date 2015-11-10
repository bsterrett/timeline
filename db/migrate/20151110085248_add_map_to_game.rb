class AddMapToGame < ActiveRecord::Migration
  def change
    add_reference :games, :map, index: true
    add_foreign_key :games, :maps
  end
end
