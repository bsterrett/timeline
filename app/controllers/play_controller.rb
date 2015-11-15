class PlayController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'application'

  def index
    render :timelinegame
  end

  def advance_game
    begin
      @match = Match.find(session[:match_id] || params[:match_id])
    rescue ActiveRecord::RecordNotFound => e
      flash.now[:errors] = e.message.to_s
      render :timelinegame, layout: false, status: 500 and return
    end
    @game = @match.game

    render :timelinegame, layout: false and return if @game.win_condition?

    if @game.status == 'not_started'
      @game.game_status = GameStatus.find_by_name('in_progress')
      @game.save
    end

    @game.advance_game_version if @game.require_advance_game_version?
    @game.advance_frame

    if @game.win_condition?
      @game.game_status = GameStatus.find_by_name('finished')
      @game.save
    end

    render :timelinegame, layout: false
  end

  def create_player_action
    @match = Match.find(session[:match_id] || params[:match_id])
    @game = @match.game
    @player = Player.find(session[:player_id] || params[:player_id])

    render :text => "this isnt a valid player" and return unless @game.players.include? @player

    @player_action_type = PlayerActionType.find_by_name(params[:player_action_type])
    @actionable = nil # TODO: implement actionable type, like troop, tower, etc.
    @quantity = params[:quantity] || 0
    @causal = params.has_key?(:causal) ? !!/true/i.match(params[:causal]) : true
    @acausal_target_frame = params[:acausal_target_frame]

    if params.has_key?(:actionable_type) && params.has_key?(:actionable_id)
      klass_name = params[:actionable_type].camelize
      actionable_klass = klass_name.constantize
      @actionable = actionable_klass.find(params[:actionable_id])
    end

    game_event = @match.game.game_event_list.game_events.build({
      player: @player,
      causal: @causal,
      frame: @match.game.current_frame,
      acausal_target_frame: @acausal_target_frame
    })
    game_event.save

    player_action = game_event.create_player_action({
      player_action_type: @player_action_type,
      player: @player,
      quantity: @quantity,
      actionable: @actionable
    })

    game_event.update_attribute(:player_action, player_action)

    begin
      player_action.enact
    rescue Exceptions::TimelineError => e
      puts "\n" + "-" * 100
      puts "#{e.class}: #{e.message}"
      e.backtrace[0..5].each do |b|
        puts "  " + b.to_s
      end
      puts "-" * 100 + "\n"
    end

    unless @causal
      @game.require_advance_game_version!
    end

    render :timelinegame, layout: false
  end
end
