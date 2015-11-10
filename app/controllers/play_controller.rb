class PlayController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new_match
    @match = Match.new
    @match.users = [User.first, User.last]

    @game = Game.new
    @game.map = Map.first
    @match.users.each do |user|
      @game.players << Player.create({ username: user.username })
    end
    ruleset = GameRuleset.new
    ruleset.max_players = @game.map.max_players || 2
    ruleset.max_resources = 100000000000
    ruleset.max_player_towers = @game.map.max_player_towers || 3
    ruleset.max_troops = 1000
    ruleset.max_slices = 100000000000
    ruleset.slice_speed_modifier = 1
    ruleset.resource_speed_modifier = 1
    ruleset.troop_speed_modifier = 1
    ruleset.base_health_modifier = 1
    ruleset.handshake_bounded_acausal_actions = true
    ruleset.freeze
    @game.game_ruleset = ruleset

    @game.game_status = GameStatus.find_by_name('not_started')
    @game.save

    @match.game = @game
    @match.save

    render :timelinegame
  end

  def advance_game
    @match = Match.find(params[:id])


    render :timelinegame
  end
end
