class CreateMatch < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.boolean :started, null: false, default: false
      t.boolean :concluded, null: false, default: false

      t.timestamps null: false
    end
  end
end
