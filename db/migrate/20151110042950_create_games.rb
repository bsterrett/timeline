class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :oldest_frame, default: 0, null: false, limit: 8

      t.timestamps null: false
    end
  end
end
