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

ActiveRecord::Schema.define(version: 20170208143054) do

  create_table "activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",                         null: false
    t.integer  "participate_count", default: 0, null: false
    t.integer  "finish_count",      default: 0, null: false
    t.integer  "finish_day_count",  default: 0, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "activity_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.string   "content",     null: false
    t.integer  "reply_to"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["activity_id"], name: "index_activity_comments_on_activity_id", using: :btree
    t.index ["user_id"], name: "index_activity_comments_on_user_id", using: :btree
  end

  create_table "daily_finish_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["activity_id"], name: "index_daily_finish_records_on_activity_id", using: :btree
    t.index ["user_id"], name: "index_daily_finish_records_on_user_id", using: :btree
  end

  create_table "finish_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.integer  "finish_day_count", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["activity_id"], name: "index_finish_records_on_activity_id", using: :btree
    t.index ["user_id"], name: "index_finish_records_on_user_id", using: :btree
  end

  create_table "participation_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.integer  "finish_day_count", default: 0,     null: false
    t.boolean  "is_finished",      default: false, null: false
    t.datetime "finish_time"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["activity_id"], name: "index_participation_records_on_activity_id", using: :btree
    t.index ["is_finished"], name: "index_participation_records_on_is_finished", using: :btree
    t.index ["user_id"], name: "index_participation_records_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.integer  "ongoing_activity_id"
    t.string   "username",                            null: false
    t.integer  "activity_id"
    t.integer  "finish_day_count",       default: 0,  null: false
    t.integer  "combo_day_count",        default: 0,  null: false
    t.date     "participate_date"
    t.date     "last_finish_date"
    t.string   "nickname",                            null: false
    t.index ["activity_id"], name: "index_users_on_activity_id", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "users", "activities"
end
