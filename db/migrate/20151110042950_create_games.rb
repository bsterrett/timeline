class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :version, null: false, default: 0

      t.timestamps null: false
    end
  end
end
