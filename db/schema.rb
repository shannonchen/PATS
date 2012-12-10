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

ActiveRecord::Schema.define(:version => 20121210090311) do

  create_table "animal_medicines", :force => true do |t|
    t.integer "animal_id",                :null => false
    t.integer "medicine_id",              :null => false
    t.integer "recommended_num_of_units"
  end

  create_table "animals", :force => true do |t|
    t.string  "name",   :limit => 50,                   :null => false
    t.boolean "active",               :default => true
  end

  create_table "medicine_costs", :force => true do |t|
    t.integer "medicine_id",   :null => false
    t.integer "cost_per_unit", :null => false
    t.date    "start_date"
    t.date    "end_date"
  end

  create_table "medicines", :force => true do |t|
    t.string  "name",         :limit => 50,                    :null => false
    t.text    "description",                                   :null => false
    t.integer "stock_amount",                                  :null => false
    t.string  "method",       :limit => 50,                    :null => false
    t.string  "unit",         :limit => 50,                    :null => false
    t.boolean "vaccine",                    :default => false
  end

  create_table "notes", :force => true do |t|
    t.string  "notable_type", :limit => 50, :null => false
    t.integer "notable_id",                 :null => false
    t.string  "title",        :limit => 50, :null => false
    t.text    "content",                    :null => false
    t.integer "user_id",                    :null => false
    t.date    "date",                       :null => false
  end

  create_table "owners", :force => true do |t|
    t.string  "first_name", :limit => 25,                   :null => false
    t.string  "last_name",  :limit => 25,                   :null => false
    t.string  "street",                                     :null => false
    t.string  "city",       :limit => 50,                   :null => false
    t.string  "state",      :limit => 2,  :default => "PA"
    t.string  "zip",        :limit => 12,                   :null => false
    t.string  "email"
    t.string  "phone",      :limit => 10
    t.boolean "active",                   :default => true
  end

  create_table "pets", :force => true do |t|
    t.string  "name",          :limit => 25,                   :null => false
    t.integer "animal_id",                                     :null => false
    t.integer "owner_id",                                      :null => false
    t.boolean "female",                      :default => true
    t.date    "date_of_birth"
    t.boolean "active",                      :default => true
  end

  create_table "procedure_costs", :force => true do |t|
    t.integer "procedure_id", :null => false
    t.integer "cost",         :null => false
    t.date    "start_date"
    t.date    "end_date"
  end

  create_table "procedures", :force => true do |t|
    t.string  "name",           :limit => 50,                   :null => false
    t.text    "description"
    t.integer "length_of_time",                                 :null => false
    t.boolean "active",                       :default => true
  end

  create_table "treatments", :force => true do |t|
    t.integer "visit_id",                      :null => false
    t.integer "procedure_id",                  :null => false
    t.boolean "successful"
    t.decimal "discount",     :default => 0.0
  end

  create_table "users", :force => true do |t|
    t.string  "first_name",      :limit => 25,                    :null => false
    t.string  "last_name",       :limit => 25,                    :null => false
    t.string  "role",            :limit => 50,                    :null => false
    t.string  "username",        :limit => 100,                   :null => false
    t.string  "password_digest",                                  :null => false
    t.boolean "active",                         :default => true
  end

  add_index "users", ["username"], :name => "unique_username", :unique => true

  create_table "visit_medicines", :force => true do |t|
    t.integer "visit_id",                     :null => false
    t.integer "medicine_id",                  :null => false
    t.integer "units_given",                  :null => false
    t.decimal "discount",    :default => 0.0
  end

  create_table "visits", :force => true do |t|
    t.integer "pet_id",                        :null => false
    t.date    "date",                          :null => false
    t.integer "weight"
    t.boolean "overnight_stay"
    t.integer "total_charge",   :default => 0
  end

  add_foreign_key "animal_medicines", "animals", :name => "animal_fk", :dependent => :restrict
  add_foreign_key "animal_medicines", "medicines", :name => "medicine_fk", :dependent => :restrict

  add_foreign_key "medicine_costs", "medicines", :name => "medicine_fk", :dependent => :delete

  add_foreign_key "notes", "users", :name => "user_fk", :dependent => :restrict

  add_foreign_key "pets", "animals", :name => "animal_fk", :dependent => :restrict
  add_foreign_key "pets", "owners", :name => "owner_fk", :dependent => :restrict

  add_foreign_key "procedure_costs", "procedures", :name => "procedure_fk", :dependent => :delete

  add_foreign_key "treatments", "procedures", :name => "procedure_fk", :dependent => :restrict
  add_foreign_key "treatments", "visits", :name => "visit_fk", :dependent => :restrict

  add_foreign_key "visit_medicines", "medicines", :name => "medicine_fk", :dependent => :restrict
  add_foreign_key "visit_medicines", "visits", :name => "visit_fk", :dependent => :restrict

  add_foreign_key "visits", "pets", :name => "pet_fk", :dependent => :restrict

end
