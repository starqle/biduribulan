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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120229101048) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "comment_meta", :force => true do |t|
    t.integer  "comment_id"
    t.string   "key"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comment_meta", ["comment_id"], :name => "index_comment_meta_on_comment_id"

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "entry_id"
    t.integer  "user_id"
    t.string   "author_name"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_ip"
    t.string   "comment_type"
    t.boolean  "approved"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "comments", ["entry_id"], :name => "index_comments_on_entry_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "entries", :force => true do |t|
    t.string   "name",               :null => false
    t.integer  "entry_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.text     "excerpt"
    t.string   "status"
    t.string   "comment_status"
    t.string   "guid"
    t.integer  "menu_order"
    t.string   "entry_type"
    t.string   "mime_type"
    t.datetime "published_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "entries", ["name"], :name => "index_entries_on_name", :unique => true
  add_index "entries", ["user_id"], :name => "index_entries_on_user_id"

  create_table "entry_meta", :force => true do |t|
    t.integer  "entry_id"
    t.string   "key"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "entry_meta", ["entry_id"], :name => "index_entry_meta_on_entry_id"

  create_table "options", :force => true do |t|
    t.string   "key"
    t.string   "option_type"
    t.text     "value"
    t.boolean  "autoload"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "role_assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "role_assignments", ["role_id"], :name => "index_role_assignments_on_role_id"
  add_index "role_assignments", ["user_id"], :name => "index_role_assignments_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "taxonomies", :force => true do |t|
    t.string   "name"
    t.string   "taxonomy_type"
    t.string   "slug"
    t.text     "description"
    t.integer  "taxonomy_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "menu_order"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "taxonomy_assignments", :force => true do |t|
    t.integer  "entry_id"
    t.integer  "taxonomy_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "taxonomy_assignments", ["entry_id"], :name => "index_taxonomy_assignments_on_entry_id"
  add_index "taxonomy_assignments", ["taxonomy_id"], :name => "index_taxonomy_assignments_on_taxonomy_id"

  create_table "user_meta", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_meta", ["user_id"], :name => "index_user_meta_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
