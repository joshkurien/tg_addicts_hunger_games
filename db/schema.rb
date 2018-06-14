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

ActiveRecord::Schema.define(version: 2018_06_14_203526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "districts", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
  end

  create_table "intro_question_options", force: :cascade do |t|
    t.string "text"
    t.bigint "district_id"
    t.bigint "intro_question_id"
    t.index ["district_id"], name: "index_intro_question_options_on_district_id"
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
  end

end
