class User < ActiveRecord::Base
  acts_as_authentic

  has_and_belongs_to_many :matches

  before_save :randomize_color

  def create_player username = self.username, color = self.color
    Player.create({ username: username, color: color })
  end

  private
  def randomize_color
    self.color = "#%02x%02x%02x" % [(rand * 0xff),(rand * 0xff),(rand * 0xff)]
  end
end
