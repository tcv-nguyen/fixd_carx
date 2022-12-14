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

ActiveRecord::Schema[7.0].define(version: 2022_08_07_175032) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.text "message"
    t.datetime "commented_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "github_events", force: :cascade do |t|
    t.integer "user_id"
    t.string "event_id"
    t.string "repo_name"
    t.string "event_name"
    t.datetime "event_created_at"
    t.index ["user_id"], name: "index_github_events_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.text "body"
    t.datetime "posted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "rater_id"
    t.integer "rating"
    t.datetime "rated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rater_id"], name: "index_ratings_on_rater_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "github_username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "registered_at"
    t.string "api_token"
    t.datetime "api_token_expired_at"
    t.decimal "rating", precision: 10, scale: 1, default: "0.0"
    t.boolean "high_rating", default: false
    t.datetime "high_rating_at"
    t.index ["api_token"], name: "index_users_on_api_token"
  end

end
