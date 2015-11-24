class LobbyController < ApplicationController
  # skip_before_action :verify_authenticity_token
  layout 'application'

  def index

    unless current_user
      username = request.remote_ip
      user = User.create(username: username)

      @user_session = UserSession.new(user)
      @user_session.save

      @current_user = @user_session.user
    end

    Lobby.add_user_to_lobby @current_user

    render :lobby
  end

  def set_user_ready
    Lobby.set_user_ready current_user

    render :lobby
  end

  def set_user_unready
    Lobby.set_user_unready current_user

    render :lobby
  end
end
