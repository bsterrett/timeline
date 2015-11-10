class AddGameToMatch < ActiveRecord::Migration
  def change
    add_reference :matches, :game, index: true
    add_foreign_key :matches, :games
  end
end
