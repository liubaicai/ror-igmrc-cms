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

ActiveRecord::Schema.define(version: 20161212023758) do

  create_table "article_types", force: :cascade do |t|
    t.string   "title",                   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "alias_url",  default: ""
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title",                                           null: false
    t.text     "content",         limit: 16777214,                null: false
    t.boolean  "is_valid",                         default: true
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "user_id"
    t.integer  "article_type_id"
    t.integer  "s_type",                           default: 0
    t.string   "alias_url",                        default: ""
  end

  add_index "articles", ["content"], name: "index_articles_on_content"
  add_index "articles", ["title"], name: "index_articles_on_title"

  create_table "comments", force: :cascade do |t|
    t.string   "content",                       null: false
    t.string   "admin_comment", default: ""
    t.boolean  "is_valid",      default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "article_id"
    t.integer  "site_id"
    t.integer  "user_id"
  end

  create_table "links", force: :cascade do |t|
    t.string   "url",                     null: false
    t.string   "title",      default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "sort",       default: 0
  end

  create_table "messages", force: :cascade do |t|
    t.string   "content",                    null: false
    t.boolean  "isread",     default: false
    t.integer  "sender",                     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.text     "content",    limit: 16777214
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "title",                       default: ""
    t.string   "alias_url",                   default: ""
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "title",                  null: false
    t.integer  "level",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "site_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "site_id"
  end

  create_table "site_types", force: :cascade do |t|
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sites", force: :cascade do |t|
    t.string   "url",                                           null: false
    t.string   "title",                         default: ""
    t.text     "reason",       limit: 16777214, default: ""
    t.string   "short_reason",                  default: ""
    t.integer  "count",                         default: 0
    t.string   "images",                        default: ""
    t.string   "note",                          default: ""
    t.boolean  "is_valid",                      default: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "site_type_id"
    t.string   "alias_url",                     default: ""
  end

  add_index "sites", ["reason"], name: "index_sites_on_reason"
  add_index "sites", ["short_reason"], name: "index_sites_on_short_reason"
  add_index "sites", ["title"], name: "index_sites_on_title"
  add_index "sites", ["url"], name: "index_sites_on_url"

  create_table "sites_logs", force: :cascade do |t|
    t.string   "url",                                           null: false
    t.string   "title",                         default: ""
    t.text     "reason",       limit: 16777214, default: ""
    t.string   "short_reason",                  default: ""
    t.integer  "count",                         default: 0
    t.string   "images",                        default: ""
    t.string   "note",                          default: ""
    t.boolean  "is_valid",                      default: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "site_type_id"
    t.integer  "user_id"
    t.string   "email"
    t.string   "phone"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",                       null: false
    t.string   "password_digest",                null: false
    t.string   "phone",                          null: false
    t.string   "token",           default: ""
    t.string   "nickname",        default: ""
    t.string   "email",           default: ""
    t.string   "description",     default: ""
    t.integer  "sex",             default: 0
    t.string   "avatar",          default: ""
    t.boolean  "is_valid",        default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "permission_id"
  end

end
