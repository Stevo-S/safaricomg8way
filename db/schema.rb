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

ActiveRecord::Schema.define(version: 20170706025124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "delivery_notifications", force: :cascade do |t|
    t.string "destination", limit: 16
    t.string "delivery_status", limit: 50
    t.string "service_id", limit: 32
    t.string "correlator", limit: 50
    t.string "trace_unique_id", limit: 50
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "short_code_services", force: :cascade do |t|
    t.string "name", limit: 32
    t.string "service_id", limit: 16
    t.string "dlr_endpoint"
    t.string "subscription_endpoint"
    t.string "message_endpoint"
    t.bigint "short_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["short_code_id"], name: "index_short_code_services_on_short_code_id"
  end

  create_table "short_codes", force: :cascade do |t|
    t.string "code", limit: 6
    t.boolean "activated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sms_messages", force: :cascade do |t|
    t.string "SmsMessage"
    t.text "content"
    t.string "sender"
    t.string "destination"
    t.string "link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sms_notifications", force: :cascade do |t|
    t.text "message"
    t.string "sender_address", limit: 16
    t.string "service_id", limit: 16
    t.string "link_id"
    t.string "trace_unique_id"
    t.string "sms_service_activation_number", limit: 8
    t.datetime "date_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sync_orders", force: :cascade do |t|
    t.string "user_id", limit: 16
    t.integer "user_type"
    t.string "product_id", limit: 16
    t.string "service_id", limit: 32
    t.string "services_list"
    t.integer "update_type"
    t.string "update_description", limit: 16
    t.datetime "update_time"
    t.datetime "effective_time"
    t.datetime "expiry_time"
    t.string "transaction_id"
    t.string "order_key"
    t.integer "mdspsubexpmode"
    t.integer "object_type"
    t.boolean "rent_success"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "short_code_services", "short_codes"
end
