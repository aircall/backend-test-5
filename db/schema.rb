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

ActiveRecord::Schema.define(version: 20190804185734) do

  create_table "calls", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sid", limit: 40
    t.string "caller", limit: 20
    t.string "routing", limit: 10
    t.string "inputs", limit: 100
    t.index ["sid"], name: "index_calls_on_sid", unique: true
  end

  create_table "recordings", force: :cascade do |t|
    t.integer "calls_id"
    t.integer "duration"
    t.string "url", limit: 200
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calls_id"], name: "index_recordings_on_calls_id"
  end

end
