class GameVersion < ActiveRecord::Base
  belongs_to :game

  def version
    number
  end
  alias_method :verion_number, :version
end