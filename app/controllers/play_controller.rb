class PlayController < ApplicationController
  skip_before_action :verify_authenticity_token

  def advance_game
    begin
      @match = Match.find(session[:match_id] || params[:match_id])
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "PLAY CONTROLLER ERROR #{e.message}\n\n#{e.backtrace}"
      flash.now[:errors] = e.message.to_s
      render :timelinegame, status: 500 and return
    end
    @game = @match.game

    render nothing: true and return if @game.win_condition?

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

    render nothing: true
  end
end
