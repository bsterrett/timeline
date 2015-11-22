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

    gf = GameFabricator.new(@match, map)
    @game = gf.call

    @match.game = @game
    @match.save

    session[:match_id] = @match.id

    render 'play/timelinegame'
  rescue StandardError => e
    flash.now[:errors] = "#{e.message}\n\n#{e.backtrace.inspect[0..1000]}"
    render 'play/timelinegame', status: 500
  end
end
