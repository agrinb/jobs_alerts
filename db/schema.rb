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

ActiveRecord::Schema.define(version: 20140907200117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: true do |t|
    t.string  "url"
    t.text    "keywords"
    t.text    "last_fetch"
    t.string  "uid",        null: false
    t.integer "user_id"
    t.string  "name"
  end

  create_table "jobs", force: true do |t|
    t.string  "title"
    t.string  "url"
    t.integer "company_id"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "avatar"
  end

end
