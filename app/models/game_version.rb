class GameVersion < ActiveRecord::Base
  belongs_to :game

  def increment_current_frame! count = 1
    increment!(:current_frame, count)
  end

  def current_version
    version
  end
  alias_method :number, :current_version

  def frame
    current_frame
  end
end