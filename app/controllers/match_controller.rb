class MatchController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def show
    @match = Match.find(session[:match_id] || params[:id])
    @game = @match.game
    render 'play/timelinegame'
  rescue ActiveRecord::RecordNotFound => e
    flash.now[:errors] = e.message.to_s
    render 'play/timelinegame', status: 500
  end

  def begin
    @match = Match.find(session[:match_id] || params[:id])
    @game = @match.game

    if @game.status == 'not_started'
      @game.game_status = GameStatus.find_by_name('in_progress')
      @game.save
    end

    render 'play/timelinegame'
  rescue StandardError => e
    flash.now[:errors] = "#{e.message}\n\n#{e.backtrace.inspect[0..1000]}"
    render 'play/timelinegame', status: 500
  end

  def create
    @match = Match.new

    user_ids = params.delete(:user_ids)

    begin
      users = user_ids.map { |user_id| User.find(user_id)}
    rescue ActiveRecord::RecordNotFound => e
      flash.now[:errors] = e.message.to_s
      render 'play/timelinegame', status: 500 and return
    end

    begin
      map = Map.find(params[:map_id])
    rescue ActiveRecord::RecordNotFound => e
      flash.now[:errors] = e.message.to_s
      render 'play/timelinegame', status: 500 and return
    end

    unless users.present? and users.any? and map.present?
      flash.now[:errors] = "error getting users and/or map"
      render 'play/timelinegame', status: 500 and return
    end

    @match.users = users

    @game = Game.new

    @match.users.each do |user|
      @game.players << user.create_player
    end

    @game.map = map


    # TODO: Create map fabricator
    #   should build a map and fixtures from a template
    #   then it should populate the map with game pieces for all players

    @game.players.each do |player|
      player.map_base_spawns.create({
        map: map,
        location: 0,
        position: 0
      })

      player.map_tower_spawns.create([{
        map: map,
        location: 5,
        position: 0
      },{
        map: map,
        location: 15,
        position: 1
      },{
        map: map,
        location: 25,
        position: 2
      }])

      player.map_troop_spawns.create({
        map: map,
        location: 50,
        position: 0
      })
    end

    @game.players.each do |player|
      player.map_base_spawns.each do |map_base_spawn|
        base_attributes = {
          base_type: BaseType.find(1)
        }

        map_base_spawn.spawn base_attributes
      end
    end

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
    ruleset.fractional_health_constant = 1000.0
    ruleset.handshake_bounded_acausal_actions = true
    ruleset.rebase_to_oldest_frame_on_acausal_action = true
    ruleset.freeze
    @game.game_ruleset = ruleset

    @game.game_status = GameStatus.find_by_name('not_started')
    @game.save

    @match.game = @game
    @match.save

    session[:match_id] = @match.id

    render 'play/timelinegame'
  rescue StandardError => e
    flash.now[:errors] = "#{e.message}\n\n#{e.backtrace.inspect[0..1000]}"
    render 'play/timelinegame', status: 500
  end
end
