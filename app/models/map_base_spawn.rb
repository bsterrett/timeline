class MapBaseSpawn < ActiveRecord::Base
  belongs_to :map
  belongs_to :player

  scope :unlocked, -> { where('spawn_locked is true') }
  scope :locked, -> { where('spawn_locked is false') }

  SPAWN_CLASS = Base
  LOCK_AFTER_SPAWN = true

  def spawn piece_attributes
    unless self.spawn_locked
      spawn_lock! if LOCK_AFTER_SPAWN
      SPAWN_CLASS.send :create, merge_spawn_attributes(piece_attributes)
    else
      raise Exceptions::LockedSpawnError, "Could not create #{SPAWN_CLASS} for at locked spawn #{self.class} #{self.id}"
    end
  end

  def merge_spawn_attributes attributes
    attributes[:player] = self.player

    [:location, :position].each do |attribute_name|
      attributes[attribute_name] = self.send(attribute_name) if valid_attribute?(attribute_name)
    end

    attributes
  end

  def valid_attribute? attribute_name
    # TODO: make this not based on column name
    #   should be able to assign player with this
    self.has_attribute?(attribute_name.to_s) and SPAWN_CLASS.column_names.include?(attribute_name.to_s)
  end

  def spawn_locked?
    spawn_locked
  end
  alias_method :locked?, :spawn_locked?

  def spawn_lock!
    update_attribute(:spawn_locked, true)
  end
  alias_method :lock!, :spawn_lock!
end
