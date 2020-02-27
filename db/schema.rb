# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_200_223_221_140) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'games', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'user_id'
    t.integer 'white_player_id'
    t.integer 'black_player_id'
    t.string 'current_status'
    t.string 'current_user'
    t.integer 'turn_player_id'
    t.integer 'winner_player_id'
    t.integer 'loser_player_id'
    t.index ['user_id'], name: 'index_games_on_user_id'
  end

  create_table 'pieces', force: :cascade do |t|
    t.integer 'x_position'
    t.integer 'y_position'
    t.string 'piece_type'
    t.integer 'player_id'
    t.integer 'game_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'white'
    t.string 'name'
    t.boolean 'captured', default: false, null: false
    t.integer 'move_number', default: 0
    t.integer 'king_check', default: 0
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.inet 'current_sign_in_ip'
    t.inet 'last_sign_in_ip'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end
end
