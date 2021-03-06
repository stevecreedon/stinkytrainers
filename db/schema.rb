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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120921122225) do

  create_table "external_players", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "external_players_games", :id => false, :force => true do |t|
    t.integer "external_player_id"
    t.integer "game_id"
  end

  add_index "external_players_games", ["external_player_id"], :name => "index_external_players_games_on_external_player_id"
  add_index "external_players_games", ["game_id"], :name => "index_external_players_games_on_game_id"

  create_table "games", :force => true do |t|
    t.string   "location"
    t.datetime "at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "sport_id"
    t.integer  "owner_id"
  end

  create_table "games_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "game_id"
  end

  add_index "games_users", ["game_id"], :name => "index_games_users_on_game_id"
  add_index "games_users", ["user_id"], :name => "index_games_users_on_user_id"

  create_table "sports", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sports_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "sport_id"
  end

  add_index "sports_users", ["sport_id"], :name => "index_sports_users_on_sport_id"
  add_index "sports_users", ["user_id"], :name => "index_sports_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
