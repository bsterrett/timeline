class GameEvent < ActiveRecord::Base
  belongs_to :game_event_list
  belongs_to :player
end
