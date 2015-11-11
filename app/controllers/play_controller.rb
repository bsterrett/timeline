class PlayController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'application'

  def index
    render :timelinegame
  end

  def new_match
    @match = Match.new
    @match.users = [User.first, User.last]

    @game = Game.new

    @match.users.each do |user|
      @game.players << Player.create({ username: user.username })
    end

    map = Map.first
    map.map_base_spawns.each do |map_base_spawn|
      @game.players.each do |player|
        player.bases.build({
          location: map_base_spawn.location,
          position: map_base_spawn.position
        })
      end
    end

    @game.map = map

    ruleset = GameRuleset.new
    ruleset.max_players = @game.map.max_players || 2
    ruleset.max_resources = 100000000000
    ruleset.max_player_towers = @game.map.max_player_towers || 3
    ruleset.max_troops = 1000
    ruleset.max_frames = 100000000000
    ruleset.frame_speed_modifier = 1
    ruleset.resource_speed_modifier = 1
    ruleset.troop_speed_modifier = 1
    ruleset.base_health_modifier = 1
    ruleset.handshake_bounded_acausal_actions = true
    ruleset.rebase_to_oldest_frame_on_acausal_action = true
    ruleset.freeze
    @game.game_ruleset = ruleset

    @game.game_status = GameStatus.find_by_name('not_started')
    @game.save

    @match.game = @game
    @match.save

    render :timelinegame, layout: false
  end

  def advance_game
    @match = Match.find(params[:match_id])
    @game = @match.game

    if @game.status == 'not_started'
      @game.game_status = GameStatus.find_by_name('in_progress')
      @game.save
    end

    @game.advance_game_version if @game.require_advance_game_version?
    @game.advance_frame

    render :timelinegame, layout: false
  end

  def create_player_action
    @match = Match.find(params[:match_id])
    @game = @match.game
    @player = Player.find(params[:player_id])
    @player_action_type = PlayerActionType.find_by_name(params[:player_action_type])
    @quantity = params[:quantity] || 0
    @causal = params[:causal] || true
    @acausal_target_frame = params[:acausal_target_frame]

    game_event = @match.game.game_event_list.game_events.build({
      player: @player,
      causal: @causal,
      frame: @match.game.current_frame,
      acausal_target_frame: @acausal_target_frame
    })

byebug

    unless !!@causal
      @game.require_advance_game_version!
    end

    game_event.save

    render :timelinegame, layout: false
  end
end
