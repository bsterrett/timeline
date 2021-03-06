# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151123073756) do

  create_table "base_types", force: :cascade do |t|
    t.string  "name",         limit: 255, null: false
    t.string  "display_name", limit: 255, null: false
    t.integer "base_attack",  limit: 4,   null: false
    t.integer "base_defense", limit: 4,   null: false
    t.integer "base_range",   limit: 4,   null: false
    t.integer "base_speed",   limit: 4,   null: false
  end

  create_table "bases", force: :cascade do |t|
    t.integer  "player_id",    limit: 4
    t.decimal  "health",                 precision: 11, scale: 10, default: 1.0, null: false
    t.integer  "level",        limit: 4,                           default: 0,   null: false
    t.integer  "location",     limit: 4,                                         null: false
    t.integer  "position",     limit: 4,                                         null: false
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.integer  "base_type_id", limit: 4
  end

  add_index "bases", ["base_type_id"], name: "index_bases_on_base_type_id", using: :btree
  add_index "bases", ["player_id"], name: "index_bases_on_player_id", using: :btree

  create_table "game_event_lists", force: :cascade do |t|
    t.integer  "game_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "game_event_lists", ["game_id"], name: "index_game_event_lists_on_game_id", using: :btree

  create_table "game_events", force: :cascade do |t|
    t.integer  "game_event_list_id",   limit: 4
    t.integer  "player_id",            limit: 4
    t.boolean  "causal",                         default: true, null: false
    t.integer  "frame",                limit: 8,                null: false
    t.integer  "acausal_target_frame", limit: 8
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "player_action_id",     limit: 4
  end

  add_index "game_events", ["frame"], name: "index_game_events_on_frame", using: :btree
  add_index "game_events", ["game_event_list_id"], name: "index_game_events_on_game_event_list_id", using: :btree
  add_index "game_events", ["player_action_id"], name: "index_game_events_on_player_action_id", using: :btree
  add_index "game_events", ["player_id"], name: "index_game_events_on_player_id", using: :btree

  create_table "game_statuses", force: :cascade do |t|
    t.string "name",         limit: 255, null: false
    t.string "display_name", limit: 255, null: false
  end

  create_table "game_versions", force: :cascade do |t|
    t.integer  "game_id",        limit: 4
    t.integer  "version",        limit: 4, null: false
    t.integer  "starting_frame", limit: 8, null: false
    t.integer  "current_frame",  limit: 8, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "game_versions", ["game_id"], name: "index_game_versions_on_game_id", using: :btree
  add_index "game_versions", ["version"], name: "index_game_versions_on_version", using: :btree

  create_table "games", force: :cascade do |t|
    t.integer  "oldest_frame",                 limit: 8, default: 0,     null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "game_status_id",               limit: 4
    t.integer  "map_id",                       limit: 4
    t.integer  "current_game_version_id",      limit: 4
    t.boolean  "require_advance_game_version",           default: false, null: false
  end

  add_index "games", ["current_game_version_id"], name: "index_games_on_current_game_version_id", using: :btree
  add_index "games", ["game_status_id"], name: "index_games_on_game_status_id", using: :btree
  add_index "games", ["map_id"], name: "index_games_on_map_id", using: :btree

  create_table "map_base_spawns", force: :cascade do |t|
    t.integer  "map_id",       limit: 4
    t.integer  "location",     limit: 4,                 null: false
    t.integer  "position",     limit: 4,                 null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "spawn_locked",           default: false
    t.integer  "player_id",    limit: 4,                 null: false
  end

  add_index "map_base_spawns", ["map_id"], name: "index_map_base_spawns_on_map_id", using: :btree
  add_index "map_base_spawns", ["player_id"], name: "index_map_base_spawns_on_player_id", using: :btree

  create_table "map_tower_spawns", force: :cascade do |t|
    t.integer  "map_id",       limit: 4
    t.integer  "location",     limit: 4,                 null: false
    t.integer  "position",     limit: 4,                 null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "spawn_locked",           default: false
    t.integer  "player_id",    limit: 4,                 null: false
  end

  add_index "map_tower_spawns", ["map_id"], name: "index_map_tower_spawns_on_map_id", using: :btree
  add_index "map_tower_spawns", ["player_id"], name: "index_map_tower_spawns_on_player_id", using: :btree

  create_table "map_troop_spawns", force: :cascade do |t|
    t.integer  "map_id",       limit: 4
    t.integer  "location",     limit: 4,                 null: false
    t.integer  "position",     limit: 4,                 null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "spawn_locked",           default: false
    t.integer  "player_id",    limit: 4,                 null: false
  end

  add_index "map_troop_spawns", ["map_id"], name: "index_map_troop_spawns_on_map_id", using: :btree
  add_index "map_troop_spawns", ["player_id"], name: "index_map_troop_spawns_on_player_id", using: :btree

  create_table "maps", force: :cascade do |t|
    t.string   "name",              limit: 255,               null: false
    t.string   "display_name",      limit: 255,               null: false
    t.integer  "max_players",       limit: 4,     default: 2, null: false
    t.integer  "max_player_towers", limit: 4,                 null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.text     "map_template",      limit: 65535
  end

  create_table "matches", force: :cascade do |t|
    t.boolean  "started",              default: false, null: false
    t.boolean  "concluded",            default: false, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "game_id",    limit: 4
  end

  add_index "matches", ["game_id"], name: "index_matches_on_game_id", using: :btree

  create_table "matches_users", force: :cascade do |t|
    t.integer "user_id",  limit: 4
    t.integer "match_id", limit: 4
  end

  add_index "matches_users", ["match_id"], name: "index_matches_users_on_match_id", using: :btree
  add_index "matches_users", ["user_id"], name: "index_matches_users_on_user_id", using: :btree

  create_table "player_action_types", force: :cascade do |t|
    t.string "name",         limit: 255, null: false
    t.string "display_name", limit: 255, null: false
  end

  create_table "player_actions", force: :cascade do |t|
    t.integer  "player_action_type_id", limit: 4
    t.integer  "player_id",             limit: 4
    t.integer  "actionable_id",         limit: 4
    t.string   "actionable_type",       limit: 255
    t.integer  "quantity",              limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "player_actions", ["actionable_type", "actionable_id"], name: "index_player_actions_on_actionable_type_and_actionable_id", using: :btree
  add_index "player_actions", ["player_action_type_id"], name: "index_player_actions_on_player_action_type_id", using: :btree
  add_index "player_actions", ["player_id"], name: "index_player_actions_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.integer  "game_id",    limit: 4
    t.integer  "resources",  limit: 8,   default: 1000, null: false
    t.string   "username",   limit: 255,                null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "color",      limit: 255,                null: false
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id", using: :btree

  create_table "tower_types", force: :cascade do |t|
    t.string  "name",         limit: 255, null: false
    t.string  "display_name", limit: 255, null: false
    t.integer "base_attack",  limit: 4,   null: false
    t.integer "base_defense", limit: 4,   null: false
    t.integer "base_speed",   limit: 4,   null: false
    t.integer "base_cost",    limit: 4,   null: false
    t.integer "base_range",   limit: 4,   null: false
  end

  create_table "towers", force: :cascade do |t|
    t.integer  "player_id",     limit: 4
    t.integer  "tower_type_id", limit: 4
    t.integer  "level",         limit: 4,                           default: 0,   null: false
    t.integer  "location",      limit: 4,                                         null: false
    t.integer  "position",      limit: 4,                                         null: false
    t.decimal  "health",                  precision: 11, scale: 10, default: 1.0, null: false
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

  add_index "towers", ["player_id"], name: "index_towers_on_player_id", using: :btree
  add_index "towers", ["tower_type_id"], name: "index_towers_on_tower_type_id", using: :btree

  create_table "troop_types", force: :cascade do |t|
    t.string  "name",         limit: 255, null: false
    t.string  "display_name", limit: 255, null: false
    t.integer "base_attack",  limit: 4,   null: false
    t.integer "base_defense", limit: 4,   null: false
    t.integer "base_speed",   limit: 4,   null: false
    t.integer "base_cost",    limit: 4,   null: false
    t.integer "base_range",   limit: 4,   null: false
  end

  create_table "troops", force: :cascade do |t|
    t.integer  "player_id",     limit: 4
    t.integer  "troop_type_id", limit: 4
    t.integer  "location",      limit: 4,                                         null: false
    t.decimal  "health",                  precision: 11, scale: 10, default: 1.0, null: false
    t.integer  "level",         limit: 4,                           default: 0,   null: false
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

  add_index "troops", ["player_id"], name: "index_troops_on_player_id", using: :btree
  add_index "troops", ["troop_type_id"], name: "index_troops_on_troop_type_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",          limit: 255, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "color",             limit: 255, null: false
    t.string   "persistence_token", limit: 255
  end

  add_foreign_key "bases", "base_types"
  add_foreign_key "bases", "players"
  add_foreign_key "game_event_lists", "games"
  add_foreign_key "game_events", "game_event_lists"
  add_foreign_key "game_events", "player_actions"
  add_foreign_key "game_events", "players"
  add_foreign_key "game_versions", "games"
  add_foreign_key "games", "game_statuses"
  add_foreign_key "games", "game_versions", column: "current_game_version_id"
  add_foreign_key "games", "maps"
  add_foreign_key "map_base_spawns", "maps"
  add_foreign_key "map_base_spawns", "players"
  add_foreign_key "map_tower_spawns", "maps"
  add_foreign_key "map_tower_spawns", "players"
  add_foreign_key "map_troop_spawns", "maps"
  add_foreign_key "map_troop_spawns", "players"
  add_foreign_key "matches", "games"
  add_foreign_key "matches_users", "matches"
  add_foreign_key "matches_users", "users"
  add_foreign_key "player_actions", "players"
  add_foreign_key "players", "games"
  add_foreign_key "towers", "players"
  add_foreign_key "towers", "tower_types"
  add_foreign_key "troops", "players"
  add_foreign_key "troops", "troop_types"
end
