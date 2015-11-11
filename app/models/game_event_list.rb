class GameEventList < ActiveRecord::Base
  belongs_to :game

  has_many :game_events

  def last
    game_events.last
  end

  def first
    game_events.first
  end

  def last_acausal_event
    game_events.select { |ge| ge.acausal? }.last
  end
end
