class GameRuleset
  attr_accessor :max_players,
                :max_resources,
                :max_player_towers,
                :max_troops,
                :max_frames,
                :frame_speed_modifier,
                :resource_speed_modifier,
                :troop_speed_modifier,
                :base_health_modifier,
                :fractional_health_constant,
                :handshake_bounded_acausal_actions,
                :rebase_to_oldest_frame_on_acausal_action
end