class CreatePlayerActionType < ActiveRecord::Migration
  def change
    create_table :player_action_types do |t|
      t.string :name, null: false
      t.string :display_name, null: false
    end
  end
end
