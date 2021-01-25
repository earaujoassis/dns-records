# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_25_205012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hostnames", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address"], name: "index_hostnames_on_address", unique: true
  end

  create_table "hostnames_records", id: false, force: :cascade do |t|
    t.bigint "hostname_id", null: false
    t.bigint "record_id", null: false
    t.index ["hostname_id", "record_id"], name: "index_hostnames_records_on_hostname_id_and_record_id", unique: true
  end

  create_table "records", force: :cascade do |t|
    t.string "ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ip"], name: "index_records_on_ip", unique: true
  end

end
