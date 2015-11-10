class GameEventList < ActiveRecord::Base
  belongs_to :game

  has_many :game_events
end
