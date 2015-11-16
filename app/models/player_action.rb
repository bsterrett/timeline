class PlayerAction < ActiveRecord::Base
  belongs_to :player
  belongs_to :player_action_type

  belongs_to :actionable, polymorphic: true

  def enact
    case player_action_type.name
    when 'build_tower'
      quantity.times do
        ensure_sufficient_resources_for_actionable_cost

        tower_spawn = player.get_next_available_tower_spawn

        unless tower_spawn.nil?
          tower_attributes = {
            tower_type: actionable
          }

          tower = tower_spawn.spawn tower_attributes

          if tower.present?
            deduct_actionable_cost_from_resources
          end
        else
          raise Exceptions::NoAvailableSpawnError, "No available tower spawn for Player id #{player.id}"
        end
      end
    when 'build_troop'
      quantity.times do
        ensure_sufficient_resources_for_actionable_cost

        troop_spawn = player.get_next_available_troop_spawn

        unless troop_spawn.nil?
          troop_attributes = {
            troop_type: actionable
          }

          troop = player.get_next_available_troop_spawn.spawn troop_attributes

          if troop.present?
            deduct_actionable_cost_from_resources
          end
        else
          raise Exceptions::NoAvailableSpawnError, "No available troop spawn for Player id #{player.id}"
        end
      end
    when 'forfeit'
    when 'handshake'
    when 'research'
    when 'warp'
    end
  end

  def ensure_sufficient_resources_for_actionable_cost
    cost = actionable.base_cost
    if player.resources < cost
      raise Exceptions::InsufficientResourcesError, "Player id #{player.id} has insufficient resources for #{actionable.class} id #{actionable.id}"
    else
      true
    end
  end

  def deduct_actionable_cost_from_resources
    ensure_sufficient_resources_for_actionable_cost
    player.decrement!(:resources, actionable.base_cost)
  end
end
