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

ActiveRecord::Schema.define(version: 20151110054734) do

  create_table "games", force: :cascade do |t|
    t.integer  "version",    limit: 4, default: 0, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "players", force: :cascade do |t|
    t.integer  "game_id",    limit: 4
    t.integer  "resources",  limit: 8,   default: 1000,         null: false
    t.string   "name",       limit: 255, default: "Player One", null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id", using: :btree

  create_table "towers", force: :cascade do |t|
    t.integer  "player_id",  limit: 4
    t.integer  "level",      limit: 4, default: 0, null: false
    t.integer  "position",   limit: 4,             null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "towers", ["player_id"], name: "index_towers_on_player_id", using: :btree

  create_table "troops", force: :cascade do |t|
    t.integer "player_id", limit: 4
    t.integer "position",  limit: 4,                                         null: false
    t.decimal "health",              precision: 11, scale: 10, default: 1.0, null: false
    t.integer "level",     limit: 4,                           default: 0,   null: false
  end

  add_index "troops", ["player_id"], name: "index_troops_on_player_id", using: :btree

  add_foreign_key "players", "games"
  add_foreign_key "towers", "players"
  add_foreign_key "troops", "players"
end
