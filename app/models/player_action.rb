class PlayerAction < ActiveRecord::Base
  belongs_to :player
  belongs_to :player_action_type

  belongs_to :actionable, polymorphic: true

  def enact
    case player_action_type.name
    when 'build_tower'
      quantity.times do
        if player.get_next_available_tower_spawn and ensure_resources
          success = player.towers.create({
            tower_type: actionable,
            location: player.get_next_available_tower_spawn.location,
            position: player.get_next_available_tower_spawn.position
          })

          if success
            purchase_actionable
            player.get_next_available_tower_spawn.lock!
          end
        else
          raise Exceptions::NoAvailableSpawnError, "Could not create tower for player id #{player.id}"
        end
      end
    when 'build_troop'
      quantity.times do
        if player.get_next_available_troop_spawn and ensure_resources
          success = player.troops.create({
            troop_type: actionable,
            location: player.get_next_available_troop_spawn.location
          })

          if success
            purchase_actionable
          end
        else
          raise Exceptions::NoAvailableSpawnError, "Could not create troop for player id #{player.id}"
        end
      end
    when 'forfeit'
    when 'handshake'
    when 'research'
    when 'warp'
    end
  end

  def ensure_resources
    cost = actionable.base_cost
    if player.resources < cost
      raise Exceptions::InsufficientResourcesError, "Player id #{player.id} has insufficient resources for #{actionable.class} id #{actionable.id}"
    else
      true
    end
  end

  def purchase_actionable
    ensure_resources
    player.decrement!(:resources, actionable.base_cost)
  end
end
