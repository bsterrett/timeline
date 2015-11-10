class Player < ActiveRecord::Base
  belongs_to :game

  has_many :troops
  has_many :towers
  has_many :game_events
end
