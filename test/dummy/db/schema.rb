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

ActiveRecord::Schema.define(version: 20160731201356) do

  create_table "error_occurrences", force: :cascade do |t|
    t.integer  "error_id"
    t.string   "experiencer_class"
    t.integer  "experiencer_id"
    t.string   "ip"
    t.string   "user_agent"
    t.string   "referer"
    t.string   "query_string"
    t.string   "form_values"
    t.string   "param_values"
    t.string   "cookie_values"
    t.string   "header_values"
    t.integer  "ocurrence_count",   default: 1
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "error_occurrences", ["error_id"], name: "index_error_occurrences_on_error_id"
  add_index "error_occurrences", ["experiencer_id"], name: "index_error_occurrences_on_experiencer_id"
  add_index "error_occurrences", [nil], name: "index_error_occurrences_on_experiencer_type"

  create_table "errors", force: :cascade do |t|
    t.string   "error_id"
    t.string   "error_class_name"
    t.string   "error_message"
    t.string   "http_method"
    t.string   "host_name"
    t.string   "url"
    t.text     "backtrace"
    t.string   "backtrace_hash"
    t.integer  "occurrence_count", default: 1
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "errors", ["backtrace_hash"], name: "index_errors_on_backtrace_hash", unique: true

end
