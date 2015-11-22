class Game < ActiveRecord::Base
  has_many :players
  has_many :game_versions

  has_one :game_event_list

  belongs_to :game_status
  belongs_to :map
  belongs_to :current_game_version, class_name: 'GameVersion'

  after_create :init_callback

  attr_accessor :game_ruleset

  def self.in_progress
    joins(%(JOIN game_statuses ON games.game_status_id = game_statuses.id AND game_statuses.name = 'in_progress'))
  end

  def init_callback
    game_version = self.game_versions.create({ version: 0, starting_frame: 0, current_frame: 0 })
    update_attribute(:current_game_version, game_version)

    self.create_game_event_list
  end

  def require_advance_game_version!
    update_attribute(:require_advance_game_version, true)
  end

  def require_advance_game_version?
    !!require_advance_game_version
  end

  def current_frame
    current_game_version.try(:current_frame)
  end

  def current_version
    current_game_version.try(:current_version)
  end

  def status
    game_status.try(:name)
  end

  def advance_frame iterations = 1
    iterations.times do
      players.each do |player|
        player.living_game_pieces.each do |game_piece|
          # TODO: implement base attack, currently doing nothing
          game_piece.attack_best_target opposing_player_targets(player)
        end

        player.troops.living.collect(&:advance_location)

        player.receive_income
      end

      current_game_version.increment_current_frame!
      update_attribute(:oldest_frame, current_frame)
    end
  end

  def advance_game_version
    unless current_game_version.nil?
      target_frame = game_event_list.last_acausal_event.try(:acausal_target_frame) || 0
      target_version = current_game_version.version + 1

      new_version = self.game_versions.create(
        { version: target_version, starting_frame: target_frame, current_frame: target_frame }
      )
    else
      new_version = self.game_versions.create({ version: 0, starting_frame: 0, current_frame: 0 })
    end
    update_attributes({
      current_game_version: new_version,
      require_advance_game_version: false
    })
  end

  def remaining_players
    players.select do |player|
      player.bases.living.length > 0
    end
  end

  def win_condition?
    remaining_players.length == 1
  end

  private
  def opposing_players player
    players - [player]
  end

  def opposing_player_targets player
    opposing_players(player).collect(&:game_pieces).flatten.select { |piece| piece.health > 0.0 }
  end
end
