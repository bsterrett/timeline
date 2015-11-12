class MapTowerSpawn < ActiveRecord::Base
  belongs_to :map
  belongs_to :player

  def spawn_locked?
    spawn_locked
  end
  alias_method :locked?, :spawn_locked?

  def spawn_lock!
    update_attribute(:spawn_locked, true)
  end
  alias_method :lock!, :spawn_lock!
end
