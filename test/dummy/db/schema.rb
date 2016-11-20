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

ActiveRecord::Schema.define(version: 20161120204607) do

  create_table "error_occurrences", force: :cascade do |t|
    t.integer  "error_id"
    t.string   "experiencer_type"
    t.integer  "experiencer_id"
    t.string   "ip"
    t.text     "user_agent"
    t.string   "referer"
    t.text     "query_string"
    t.text     "form_values"
    t.text     "param_values"
    t.text     "cookie_values"
    t.text     "header_values"
    t.integer  "ocurrence_count",  default: 1
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "error_occurrences", ["error_id"], name: "index_error_occurrences_on_error_id"
  add_index "error_occurrences", ["experiencer_id"], name: "index_error_occurrences_on_experiencer_id"
  add_index "error_occurrences", ["experiencer_type"], name: "index_error_occurrences_on_experiencer_type"

  create_table "errors", force: :cascade do |t|
    t.text     "exception_class_name"
    t.text     "exception_message"
    t.string   "http_method"
    t.text     "host_name"
    t.text     "url"
    t.text     "backtrace"
    t.string   "backtrace_hash"
    t.integer  "occurrence_count",      default: 0
    t.datetime "last_occurred_at"
    t.string   "last_experiencer_type"
    t.integer  "last_experiencer_id"
    t.integer  "status",                default: 0
    t.string   "importance",            default: "error"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "errors", ["backtrace_hash"], name: "index_errors_on_backtrace_hash", unique: true
  add_index "errors", ["importance"], name: "index_errors_on_importance"
  add_index "errors", ["last_experiencer_id"], name: "index_errors_on_last_experiencer_id"
  add_index "errors", ["last_experiencer_type"], name: "index_errors_on_last_experiencer_type"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "permission_class",       default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
