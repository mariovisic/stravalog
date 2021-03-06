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

ActiveRecord::Schema.define(version: 20150627084119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: :cascade do |t|
    t.string   "title",                            null: false
    t.text     "body",                             null: false
    t.hstore   "strava_data",                      null: false
    t.string   "slug",                             null: false
    t.integer  "strava_activity_id",               null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.hstore   "strava_streams_data", default: {}
    t.integer  "strava_segment_id"
  end

  add_index "activities", ["created_at"], name: "index_activities_on_created_at", using: :btree
  add_index "activities", ["slug"], name: "index_activities_on_slug", unique: true, using: :btree
  add_index "activities", ["strava_activity_id"], name: "index_activities_on_strava_activity_id", unique: true, using: :btree

end
