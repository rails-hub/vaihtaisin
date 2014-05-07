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

ActiveRecord::Schema.define(version: 20131203104739) do

  create_table "colloquial_wishes", force: true do |t|
    t.integer  "wish_log_id"
    t.integer  "wish_by_id"
    t.integer  "wish_match_id"
    t.boolean  "status",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "area1"
    t.string   "area2"
    t.string   "caretype"
    t.string   "streetaddress"
    t.string   "streetnumber"
    t.string   "pobox"
    t.string   "zipcode"
    t.string   "ziparea"
    t.string   "city"
    t.string   "phone"
    t.string   "email"
    t.string   "supervisor"
    t.string   "supervisoremail"
    t.string   "supervisorphone"
    t.integer  "capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
  end

  create_table "locations_wishes", force: true do |t|
    t.integer "location_id"
    t.integer "wish_id"
    t.integer "sequence_id"
  end

  add_index "locations_wishes", ["location_id", "wish_id"], name: "locations_wishes_index", unique: true, using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.boolean  "email_contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "travel_preferences", force: true do |t|
    t.integer  "user_id"
    t.boolean  "car"
    t.boolean  "foot"
    t.boolean  "bicycle"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "invitation_token",       limit: 60
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "wish_logs", force: true do |t|
    t.integer  "wish_by_id"
    t.integer  "wish_match_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "colloquial",    default: false
  end

  create_table "wishes", force: true do |t|
    t.integer  "user_id"
    t.integer  "offer_id"
    t.datetime "valid_until"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "saved",       default: false
    t.string   "status",      default: "ACTIVE"
  end

  add_index "wishes", ["saved"], name: "index_wishes_on_saved", using: :btree

end
