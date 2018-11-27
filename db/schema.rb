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

ActiveRecord::Schema.define(version: 2018_11_27_181028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_scores", force: :cascade do |t|
    t.bigint "ww_game_id"
    t.bigint "user_id"
    t.boolean "alive"
    t.boolean "won"
    t.integer "score", default: 0
    t.string "name"
    t.integer "telegram_id"
    t.index ["telegram_id"], name: "index_game_scores_on_telegram_id"
    t.index ["user_id"], name: "index_game_scores_on_user_id"
    t.index ["ww_game_id"], name: "index_game_scores_on_ww_game_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.string "room_link"
    t.string "description"
  end

  create_table "intro_question_options", force: :cascade do |t|
    t.string "text"
    t.bigint "group_id"
    t.bigint "intro_question_id"
    t.index ["group_id"], name: "index_intro_question_options_on_group_id"
    t.index ["intro_question_id"], name: "index_intro_question_options_on_intro_question_id"
  end

  create_table "intro_questions", force: :cascade do |t|
    t.string "text"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "key"
    t.string "text"
    t.index ["key"], name: "index_responses_on_key"
  end

  create_table "seed_migration_data_migrations", id: :serial, force: :cascade do |t|
    t.string "version"
    t.integer "runtime"
    t.datetime "migrated_on"
  end

  create_table "unknown_user_records", force: :cascade do |t|
    t.bigint "game_score_id"
    t.string "name"
    t.integer "telegram_id"
    t.index ["game_score_id"], name: "index_unknown_user_records_on_game_score_id"
    t.index ["telegram_id"], name: "index_unknown_user_records_on_telegram_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "telegram_id"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.boolean "is_bot"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.jsonb "status_metadata"
    t.bigint "group_id"
    t.boolean "is_admin", default: false
    t.string "full_name"
    t.integer "score"
    t.integer "rank"
    t.index ["full_name"], name: "index_users_on_full_name", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
  end

  create_table "ww_games", force: :cascade do |t|
    t.integer "bot"
    t.datetime "game_time"
    t.integer "player_count"
    t.string "duration"
    t.index ["game_time"], name: "index_ww_games_on_game_time", unique: true
  end

  add_foreign_key "users", "groups"
end
