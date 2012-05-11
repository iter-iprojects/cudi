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

ActiveRecord::Schema.define(:version => 20111213160441) do

  create_table "actions", :force => true do |t|
    t.string   "title"
    t.string   "comments"
    t.string   "resources"
    t.string   "proyecto"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "confirmations", :force => true do |t|
    t.string   "token"
    t.text     "description"
    t.string   "souldbesend"
    t.string   "bettween"
    t.string   "begin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "confirmationusers", :force => true do |t|
    t.string   "confirmation_token"
    t.date     "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_token"
    t.string   "document_id"
  end

  create_table "cudidocs", :force => true do |t|
    t.string   "user_id"
    t.string   "typedoc"
    t.string   "namefile"
    t.text     "contain"
    t.string   "public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.date     "date"
    t.string   "version"
    t.text     "changelog"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filesuploads", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "path"
    t.string   "proyectoid"
    t.string   "userupload"
    t.string   "allow"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "futureproyectos", :force => true do |t|
    t.string   "title"
    t.string   "comments"
    t.string   "resources"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "futureproyectosactions", :force => true do |t|
    t.string   "title"
    t.string   "mainresource", :null => false
    t.string   "priority",     :null => false
    t.text     "comments"
    t.string   "resources"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "proyecto_id"
  end

  create_table "historics", :force => true do |t|
    t.string   "proyecto"
    t.string   "document_version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "snapshoot"
  end

  create_table "paintings", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  create_table "panelcontrols", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "property_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "priorities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proyectoresources", :force => true do |t|
    t.string   "proyectoid"
    t.string   "resources"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proyectos", :force => true do |t|
    t.string   "title"
    t.string   "resources"
    t.string   "status"
    t.text     "comments"
    t.string   "actions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mainresource"
    t.string   "priority"
    t.date     "finish"
    t.string   "averange"
  end

  create_table "proyectostatuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string   "proyectoid"
    t.string   "resource"
    t.string   "controller"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "proyecto_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "ou",                                  :default => ""
    t.string   "displayname",                                         :null => false
    t.string   "cn",                                                  :null => false
    t.string   "telephonenumber",                                     :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
