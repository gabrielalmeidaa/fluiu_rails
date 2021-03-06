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

ActiveRecord::Schema.define(version: 20180614150008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounting_infos", force: :cascade do |t|
    t.string "financial_spreadsheet"
    t.string "canceled_invoices"
    t.string "paycheck_changes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "month"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_accounting_infos_on_user_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "day"
    t.string "event"
    t.integer "owner"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "user_id"
    t.string "month"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invoice_file"
    t.bigint "accounting_info_id"
    t.boolean "declaration_flag"
    t.index ["accounting_info_id"], name: "index_invoices_on_accounting_info_id"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company"
    t.string "cnpj"
    t.string "cpf"
    t.string "telephone"
    t.integer "role"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "earnings_type"
    t.string "earnings_range"
    t.string "patrimonial_balance"
    t.string "dre_file"
    t.string "social_contract"
    t.string "business_licence"
    t.string "cnpj_file"
    t.string "cf_file"
    t.string "personal_file"
    t.string "das_file"
    t.string "protocol"
    t.string "fgts"
    t.string "inss"
    t.string "fau"
    t.string "tributary_sub"
    t.string "payment_installments"
    t.integer "opening_status"
    t.string "name"
    t.string "sys_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounting_infos", "users"
  add_foreign_key "documents", "users"
  add_foreign_key "invoices", "accounting_infos"
  add_foreign_key "invoices", "users"
end
