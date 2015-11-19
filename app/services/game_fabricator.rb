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

    self.freeze
  end

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
  end

  def ensure_map_and_player_count_are_compatible
    if @players.length > @map.max_players
      raise PlayerCountError, "Too many players for this map"
    elsif @players.length < @map.max_players
      raise PlayerCountError, "Too few players for this map"
    end
  end
end
