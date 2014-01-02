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

ActiveRecord::Schema.define(version: 20140102100655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: true do |t|
    t.string   "url"
    t.integer  "likes"
    t.string   "posted_at"
    t.string   "thumbnail_url"
    t.string   "full_image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "latitude",       precision: 10, scale: 7
    t.decimal  "longitude",      precision: 10, scale: 7
    t.integer  "prox"
  end

  add_index "entries", ["created_at"], name: "index_entries_on_created_at", using: :btree
  add_index "entries", ["latitude", "longitude"], name: "index_entries_on_latitude_and_longitude", using: :btree
  add_index "entries", ["latitude"], name: "index_entries_on_latitude", using: :btree
  add_index "entries", ["longitude"], name: "index_entries_on_longitude", using: :btree
  add_index "entries", ["posted_at"], name: "index_entries_on_posted_at", using: :btree
  add_index "entries", ["updated_at"], name: "index_entries_on_updated_at", using: :btree

  create_table "entries_tags", force: true do |t|
    t.integer "entry_id"
    t.integer "tag_id"
  end

  create_table "tags", force: true do |t|
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "chase",      default: false
  end

  add_index "tags", ["label"], name: "index_tags_on_label", unique: true, using: :btree

end
