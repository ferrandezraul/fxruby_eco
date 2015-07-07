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

ActiveRecord::Schema.define(version: 1) do

  create_table "children_containers", id: false, force: :cascade do |t|
    t.integer "child_id"
    t.integer "container_id"
  end

  add_index "children_containers", ["child_id"], name: "index_children_containers_on_child_id"
  add_index "children_containers", ["container_id", "child_id"], name: "index_children_containers_on_container_id_and_child_id", unique: true

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "nif"
    t.string   "customer_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.decimal  "weight",     precision: 8, scale: 3
    t.decimal  "price",      precision: 8, scale: 2
    t.decimal  "taxes",      precision: 8, scale: 2
    t.decimal  "total",      precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id"
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id"

  create_table "orders", force: :cascade do |t|
    t.date     "date"
    t.integer  "customer_id"
    t.decimal  "price",       precision: 8, scale: 2
    t.decimal  "taxes",       precision: 8, scale: 2
    t.decimal  "total",       precision: 8, scale: 2
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id"

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "price_type"
    t.decimal  "price",          precision: 8, scale: 2
    t.decimal  "taxes",          precision: 8, scale: 2
    t.decimal  "tax_percentage", precision: 4, scale: 2
    t.decimal  "total",          precision: 8, scale: 2
    t.decimal  "weight",         precision: 8, scale: 3
    t.boolean  "outdated",                               default: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

end
