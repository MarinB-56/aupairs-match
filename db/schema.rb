# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_10_121742) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.date "start"
    t.date "end"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "favoriting_user_id"
    t.bigint "favorited_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favorited_user_id"], name: "index_favorites_on_favorited_user_id"
    t.index ["favoriting_user_id"], name: "index_favorites_on_favoriting_user_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.string "status"
    t.bigint "initiated_by_id"
    t.bigint "received_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["initiated_by_id"], name: "index_matches_on_initiated_by_id"
    t.index ["received_by_id"], name: "index_matches_on_received_by_id"
  end

  create_table "user_languages", force: :cascade do |t|
    t.bigint "language_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_user_languages_on_language_id"
    t.index ["user_id"], name: "index_user_languages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "birth_date"
    t.text "description"
    t.string "nationality"
    t.string "gender"
    t.string "location"
    t.integer "number_of_children"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
  end

  add_foreign_key "availabilities", "users"
  add_foreign_key "favorites", "users", column: "favorited_user_id"
  add_foreign_key "favorites", "users", column: "favoriting_user_id"
  add_foreign_key "matches", "users", column: "initiated_by_id"
  add_foreign_key "matches", "users", column: "received_by_id"
  add_foreign_key "user_languages", "languages"
  add_foreign_key "user_languages", "users"
end
