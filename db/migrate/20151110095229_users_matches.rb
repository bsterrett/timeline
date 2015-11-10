class UsersMatches < ActiveRecord::Migration
  def change
    create_table :matches_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :match, index: true, foreign_key: true
      # t.boolean :victorious, default: nil
    end
  end
end
