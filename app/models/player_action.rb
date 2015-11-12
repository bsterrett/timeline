class PlayerAction < ActiveRecord::Base
  belongs_to :player
  belongs_to :player_action_type

  belongs_to :actionable, polymorphic: true

  def enact
    case player_action_type.name
    when 'build_tower'
      quantity.times do
        if player.get_next_available_tower_spawn
          player.towers.create({
            tower_type: actionable,
            location: player.get_next_available_tower_spawn.location,
            position: player.get_next_available_tower_spawn.position
          })

          player.get_next_available_tower_spawn.lock!
        end
      end
    when 'build_troop'
      quantity.times do
        if player.get_next_available_troop_spawn
          player.troops.create({
            troop_type: actionable,
            location: player.get_next_available_troop_spawn.location
          })
        end
      end
    when 'forfeit'
    when 'handshake'
    when 'research'
    when 'warp'
    end
  end
end
