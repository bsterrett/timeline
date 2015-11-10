class Game < ActiveRecord::Base
  has_many :players
  has_many :game_versions

  has_one :game_event_list

  belongs_to :game_status
  belongs_to :map

  after_create :init_callback

  attr_reader :current_game_version

  attr_accessor :game_ruleset

  def init_callback
    # self.players.build([{:name => "Player One"},{:name => "Player Two"}]).collect(&:save)

    @current_game_version = self.game_versions.build({ number: 0, starting_slice: 0 })
    @current_game_version.save

    self.build_game_event_list.save
  end

  def advance_game_version target_slice
    if @current_game_version
      @current_game_version = self.game_versions.build({ number: 0, starting_slice: 0 })
    else
      @current_game_version = self.game_versions.build(
        { number: @current_game_version.number, starting_slice: target_slice }
      )
    end
    @current_game_version.save
  end
end
