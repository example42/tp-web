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

ActiveRecord::Schema.define(version: 20160420170738) do

  create_table "application_confs", force: :cascade do |t|
    t.string   "name"
    t.string   "template"
    t.text     "options"
    t.string   "ensure"
    t.string   "source"
    t.string   "epp"
    t.string   "content"
    t.string   "base_dir"
    t.string   "path"
    t.string   "mode"
    t.string   "owner"
    t.string   "group"
    t.boolean  "config_file_notify"
    t.boolean  "config_file_require"
    t.boolean  "debug"
    t.string   "debug_dir"
    t.string   "data_module"
    t.integer  "application_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "application_confs", ["application_id"], name: "index_application_confs_on_application_id"

  create_table "application_dirs", force: :cascade do |t|
    t.string   "name"
    t.string   "ensure"
    t.string   "source"
    t.string   "vcsrepo"
    t.string   "base_dir"
    t.string   "path"
    t.string   "mode"
    t.string   "owner"
    t.string   "group"
    t.boolean  "config_dir_notify"
    t.boolean  "config_dir_require"
    t.boolean  "purge"
    t.boolean  "recurse"
    t.boolean  "force"
    t.boolean  "debug"
    t.string   "debug_dir"
    t.string   "data_module"
    t.integer  "application_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "application_dirs", ["application_id"], name: "index_application_dirs_on_application_id"

  create_table "application_puppis", force: :cascade do |t|
    t.string   "ensure"
    t.boolean  "check_enable"
    t.string   "check_template"
    t.boolean  "info_enable"
    t.string   "info_template"
    t.boolean  "info_defaults"
    t.boolean  "log_enable"
    t.string   "data_module"
    t.boolean  "verbose"
    t.integer  "application_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "application_puppis", ["application_id"], name: "index_application_puppis_on_application_id"

  create_table "applications", force: :cascade do |t|
    t.string   "name"
    t.string   "ensure"
    t.boolean  "auto_repo"
    t.boolean  "puppi_enable"
    t.boolean  "test_enable"
    t.string   "test_template"
    t.boolean  "debug_enable"
    t.string   "debug_dir"
    t.string   "data_module"
    t.integer  "manifest_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "applications", ["manifest_id"], name: "index_applications_on_manifest_id"

  create_table "key_values", force: :cascade do |t|
    t.string   "type"
    t.string   "key"
    t.string   "value"
    t.integer  "keyable_id"
    t.string   "keyable_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "key_values", ["keyable_type", "keyable_id"], name: "index_key_values_on_keyable_type_and_keyable_id"

  create_table "manifests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
