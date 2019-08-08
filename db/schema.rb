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

ActiveRecord::Schema.define(version: 20190807152446) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calls", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "from", limit: 20
    t.string "direction", limit: 20
    t.string "called", limit: 20
    t.string "sid", limit: 34
    t.string "status", limit: 20
    t.integer "forwarding", default: 0
    t.integer "duration"
    t.index ["sid"], name: "index_calls_on_sid", unique: true
  end

  create_table "records", force: :cascade do |t|
    t.string "sid", limit: 40
    t.integer "duration"
    t.string "link", limit: 150
    t.bigint "call_id"
    t.index ["call_id"], name: "index_records_on_call_id"
  end

  add_foreign_key "records", "calls"
end
