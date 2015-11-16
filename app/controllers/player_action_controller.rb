class PlayerActionController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def create
    @match = Match.find(session[:match_id] || params[:match_id])
    @game = @match.game
    player = Player.find(session[:player_id] || params[:player_id])

    unless @game.players.include? player
      flash.now[:errors] = "This is not a valid player"
      render 'play/timelinegame', status: 500 and return
    end

    player_action_type = PlayerActionType.find_by_name(params[:player_action_type])
    quantity = params[:quantity] || 0
    causal = params.has_key?(:causal) ? !!/true/i.match(params[:causal]) : true
    acausal_target_frame = params[:acausal_target_frame]

    if params.has_key?(:actionable_type) && params.has_key?(:actionable_id)
      klass_name = params[:actionable_type].camelize
      actionable_klass = klass_name.constantize
      actionable = actionable_klass.find(params[:actionable_id])
    else
      actionable = nil
    end

    game_event = @match.game.game_event_list.game_events.build({
      player: player,
      causal: causal,
      frame: @match.game.current_frame,
      acausal_target_frame: acausal_target_frame
    })
    game_event.save

    player_action = game_event.create_player_action({
      player_action_type: player_action_type,
      player: player,
      quantity: quantity,
      actionable: actionable
    })

    game_event.update_attribute(:player_action, player_action)

    begin
      player_action.enact
    rescue Exceptions::PlayerConstraintsError => e
      puts "\n" + "-" * 100
      puts "#{e.class}: #{e.message}"
      e.backtrace[0..5].each do |b|
        puts "  " + b.to_s
      end
      puts "-" * 100 + "\n"
    end

    unless causal
      @game.require_advance_game_version!
    end

    render 'play/timelinegame'
  rescue StandardError => e
    flash.now[:errors] = "#{e.message}\n\n#{e.backtrace.inspect[0..1000]}"
    render 'play/timelinegame', status: 500
  end
end
