class GameFabricator
  attr_accessor :match, :map, :users, :players

  class GameFabricatorError < Exceptions::TimelineError; end
  class DoubleFabricationError < GameFabricatorError; end
  class NoPlayerError < GameFabricatorError; end
  class NoMapError < GameFabricatorError; end
  class UserMatchAssociationError < GameFabricatorError; end
  class PlayerUserAssociationError < GameFabricatorError; end
  class PlayerCountError < GameFabricatorError; end

  def initialize(*args)
    @users = []
    @players = []
    @game = nil

    # TODO: allow create by hash

    args.flatten.each do |arg|
      case arg
      when Match
        @match = arg
      when Map
        @map = arg
      when User
        @users << arg
      when Player
        @players << arg
      end
    end
  end

  def call
    if self.frozen?
      raise DoubleFabricationError, 'Cannot use a game fabricator to create more than one game'
    end

    ensure_players_and_users_are_populated
    ensure_map_is_populated
    ensure_game_is_populated

    self.freeze

    @game
  end

  private

  def ensure_source_for_players
    if @match.nil? and @users.empty? and @players.empty?
      raise NoPlayerError, 'No match, users, or players provided to game fabricator, so players could not be created'
    end
  end

  def ensure_users_and_match_are_valid
    if @match.present? and @users.any?
      if @users.select{ |user| user.match == @match }.emtpy?
        raise UserMatchAssociationError, 'Provided users do not belong to provided match'
      end
    end
  end

  def ensure_users_and_players_are_valid
    if @players.any? and @users.any?
      if @players.select{ |player| @users.include? player.user }.emtpy?
        raise PlayerUserAssociationError, 'Provided players do not belong to provided users'
      end
    end
  end

  def ensure_players_and_users_are_populated
    ensure_source_for_players
    ensure_users_and_match_are_valid
    ensure_users_and_players_are_valid

    unless @users.any? or @match.nil?
      @users = @match.users
    end

    unless @players.any?
      @players = @users.collect(&:create_player)
    end
  end

  def ensure_map_is_populated
    unless @map.present?
      raise NoMapError, "No map provided to game fabricator"
    end
    ensure_map_and_player_count_are_compatible

    populate_map_base_spawns
    populate_map_tower_spawns
    populate_map_troop_spawns

    populate_bases

    @map
  end

  def ensure_map_and_player_count_are_compatible
    if @players.length > @map.max_players
      raise PlayerCountError, "Too many players for this map"
    elsif @players.length < @map.max_players
      raise PlayerCountError, "Too few players for this map"
    end
  end

  def populate_map_base_spawns
    map_template[:map_base_spawns].each do |map_base_spawn|
      @players.each do |player|
        player.map_base_spawns.create({
          location: map_base_spawn[:location],
          position: map_base_spawn[:position],
          spawn_locked: false,
          map: @map
        })
      end
    end
  end

  def populate_map_tower_spawns
    map_template[:map_tower_spawns].each do |map_tower_spawn|
      @players.each do |player|
        player.map_tower_spawns.create({
          location: map_tower_spawn[:location],
          position: map_tower_spawn[:position],
          spawn_locked: false,
          map: @map
        })
      end
    end
  end

  def populate_map_troop_spawns
    map_template[:map_troop_spawns].each do |map_troop_spawn|
      @players.each do |player|
        player.map_troop_spawns.create({
          location: map_troop_spawn[:location],
          position: map_troop_spawn[:position],
          spawn_locked: false,
          map: @map
        })
      end
    end
  end

  def populate_bases
    @players.each do |player|
      player.map_base_spawns.each do |map_base_spawn|
        base_attributes = {
          base_type: BaseType.find(1)
        }

        map_base_spawn.spawn base_attributes
      end
    end
  end

  def ensure_game_is_populated
    @game = Game.new
    @game.map = @map
    @game.players = @players
    @game.game_ruleset = game_ruleset
    @game.game_status = GameStatus.find_by_name('not_started')
    @game.save
    @game
  end

  def game_ruleset
    return @ruleset unless @ruleset.nil?

    @ruleset = GameRuleset.new
    @ruleset.max_players = @map.max_players || 2
    @ruleset.max_resources = 100000000000
    @ruleset.max_player_towers = @map.max_player_towers || 3
    @ruleset.max_troops = 1000
    @ruleset.max_frames = 100000000000
    @ruleset.frame_speed_modifier = 1
    @ruleset.resource_speed_modifier = 1
    @ruleset.troop_speed_modifier = 1
    @ruleset.base_health_modifier = 1
    @ruleset.fractional_health_constant = 1000.0
    @ruleset.handshake_bounded_acausal_actions = true
    @ruleset.rebase_to_oldest_frame_on_acausal_action = true
    @ruleset.freeze
    @ruleset
  end

  def map_template
    @map_template ||= JSON.parse(map.map_template, symbolize_names: true)
  end
end
