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

ActiveRecord::Schema.define(version: 2022_03_07_023936) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: :cascade do |t|
    t.integer "sento_id"
    t.integer "post_id"
    t.integer "user_id"
    t.string "url"
  end

  create_table "like_posts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
  end

  create_table "like_sentos", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sento_id"
  end

  create_table "moives", force: :cascade do |t|
    t.integer "sento_id"
    t.integer "post_id"
    t.integer "user_id"
    t.string "url"
  end

  create_table "posts", force: :cascade do |t|
    t.string "comment"
    t.integer "sento_id"
    t.integer "user_id"
  end

  create_table "sentos", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "osusume"
    t.string "homepage_url"
    t.string "place_id"
    t.string "img_url"
    t.string "cost"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.integer "point", default: 0
    t.string "rank", default: "normal"
  end

end
