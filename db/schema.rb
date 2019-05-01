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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 2019_05_01_175412) do
=======
ActiveRecord::Schema.define(version: 2019_05_01_181833) do
>>>>>>> d84b5282587a95747e0a7d18416d7bc10d101515

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

<<<<<<< HEAD
=======
  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_products_joins", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "product_id"
    t.index ["category_id"], name: "index_categories_products_joins_on_category_id"
    t.index ["product_id"], name: "index_categories_products_joins_on_product_id"
  end

>>>>>>> d84b5282587a95747e0a7d18416d7bc10d101515
  create_table "merchants", force: :cascade do |t|
    t.string "username"
    t.string "name"
    t.integer "uid"
    t.string "provider"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "status"
<<<<<<< HEAD
=======
    t.string "email"
    t.string "address"
    t.string "name"
    t.string "cc_name"
    t.date "cc_exp"
    t.integer "cc_num"
>>>>>>> d84b5282587a95747e0a7d18416d7bc10d101515
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.string "description"
    t.integer "stock"
    t.string "photo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "merchant_id"
    t.index ["merchant_id"], name: "index_products_on_merchant_id"
  end

<<<<<<< HEAD
=======
  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

>>>>>>> d84b5282587a95747e0a7d18416d7bc10d101515
  add_foreign_key "products", "merchants"
end
