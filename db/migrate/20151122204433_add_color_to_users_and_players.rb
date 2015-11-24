class AddColorToUsersAndPlayers < ActiveRecord::Migration
  def change
    add_column :users, :color, :string, null: false
    add_column :players, :color, :string, null: false
  end
end
