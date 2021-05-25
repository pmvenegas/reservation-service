# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_25_053623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guests", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone_numbers", array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_guests_on_email", unique: true
  end

  create_table "reservation_requests", force: :cascade do |t|
    t.jsonb "payload", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "guests", default: 0, null: false
    t.integer "adults", default: 0, null: false
    t.integer "children", default: 0, null: false
    t.integer "infants", default: 0, null: false
    t.integer "nights", default: 0, null: false
    t.string "status", null: false
    t.jsonb "guest_details", default: {}, null: false
    t.string "currency", null: false
    t.decimal "payout_amount", precision: 10, scale: 2, null: false
    t.decimal "security_amount", precision: 10, scale: 2, null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.jsonb "misc", default: {}, null: false
    t.bigint "guest_id", null: false
    t.bigint "reservation_request_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["guest_id"], name: "index_reservations_on_guest_id"
    t.index ["reservation_request_id"], name: "index_reservations_on_reservation_request_id"
    t.index ["start_date", "end_date", "guest_id"], name: "index_reservations_on_start_date_and_end_date_and_guest_id", unique: true
  end

  add_foreign_key "reservations", "guests"
  add_foreign_key "reservations", "reservation_requests"
end
