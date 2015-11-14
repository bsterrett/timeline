class User < ActiveRecord::Base
  has_and_belongs_to_many :matches

  def create_player
    Player.create({ username: self.username })
  end
end
