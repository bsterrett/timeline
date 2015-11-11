class Player < ActiveRecord::Base
  belongs_to :game

  has_many :troops
  has_many :towers
  has_many :bases
  has_many :game_events

  def game_pieces
    (troops + towers + bases).flatten
  end
end
