class CreatePlayerAction < ActiveRecord::Migration
  def change
    create_table :player_actions do |t|
      t.references :player_action_type, index: true, foreign_key: false
      t.references :player, index: true, foreign_key: true
      t.references :actionable, polymorphic: true, index: true
      t.integer :quantity, default: nil
    end
  end
end
