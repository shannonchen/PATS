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

ActiveRecord::Schema.define(:version => 20121210173303) do

  create_table "animal_medicines", :force => true do |t|
    t.integer "animal_id",                :null => false
    t.integer "medicine_id",              :null => false
    t.integer "recommended_num_of_units"
  end

  add_index "animal_medicines", ["animal_id"], :name => "animal_medicine_animal_idx"
  add_index "animal_medicines", ["medicine_id"], :name => "animal_medicine_medicine_idx"

  create_table "animals", :force => true do |t|
    t.string  "name",   :limit => 50,                   :null => false
    t.boolean "active",               :default => true
  end

  add_index "animals", ["name"], :name => "animals_name_idx"

  create_table "medicine_costs", :force => true do |t|
    t.integer "medicine_id",   :null => false
    t.integer "cost_per_unit", :null => false
    t.date    "start_date"
    t.date    "end_date"
  end

  add_index "medicine_costs", ["end_date"], :name => "current_medicine_cost"

  create_table "medicines", :force => true do |t|
    t.string  "name",         :limit => 50,                    :null => false
    t.text    "description",                                   :null => false
    t.integer "stock_amount",                                  :null => false
    t.string  "method",       :limit => 50,                    :null => false
    t.string  "unit",         :limit => 50,                    :null => false
    t.boolean "vaccine",                    :default => false
  end

  add_index "medicines", ["name"], :name => "medicines_name_idx"

  create_table "notes", :force => true do |t|
    t.string  "notable_type", :limit => 50, :null => false
    t.integer "notable_id",                 :null => false
    t.string  "title",        :limit => 50, :null => false
    t.text    "content",                    :null => false
    t.integer "user_id",                    :null => false
    t.date    "date",                       :null => false
  end

  add_index "notes", ["notable_type", "notable_id"], :name => "notes_noteable_idx"
  add_index "notes", ["user_id"], :name => "notes_user_idx"

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

  add_index "owners", ["email"], :name => "owners_email_idx"
  add_index "owners", ["street", "city", "state", "zip"], :name => "owners_address_idx"

  create_table "pets", :force => true do |t|
    t.string  "name",          :limit => 25,                   :null => false
    t.integer "animal_id",                                     :null => false
    t.integer "owner_id",                                      :null => false
    t.boolean "female",                      :default => true
    t.date    "date_of_birth"
    t.boolean "active",                      :default => true
  end

  add_index "pets", ["animal_id"], :name => "pets_animal_idx"
  add_index "pets", ["owner_id"], :name => "pets_owner_idx"

  create_table "procedure_costs", :force => true do |t|
    t.integer "procedure_id", :null => false
    t.integer "cost",         :null => false
    t.date    "start_date"
    t.date    "end_date"
  end

  add_index "procedure_costs", ["end_date"], :name => "current_procedure_cost"
  add_index "procedure_costs", ["procedure_id"], :name => "procedure_costs_procedure_idx"

  create_table "procedures", :force => true do |t|
    t.string  "name",           :limit => 50,                   :null => false
    t.text    "description"
    t.integer "length_of_time",                                 :null => false
    t.boolean "active",                       :default => true
  end

  add_index "procedures", ["name"], :name => "procedures_name_idx"

  create_table "treatments", :force => true do |t|
    t.integer "visit_id",                      :null => false
    t.integer "procedure_id",                  :null => false
    t.boolean "successful"
    t.decimal "discount",     :default => 0.0
  end

  add_index "treatments", ["procedure_id"], :name => "treatments_procedure_idx"
  add_index "treatments", ["visit_id"], :name => "treatments_visit_idx"

  create_table "users", :force => true do |t|
    t.string  "first_name",      :limit => 25,                    :null => false
    t.string  "last_name",       :limit => 25,                    :null => false
    t.string  "role",            :limit => 50,                    :null => false
    t.string  "username",        :limit => 100,                   :null => false
    t.string  "password_digest",                                  :null => false
    t.boolean "active",                         :default => true
  end

  add_index "users", ["username"], :name => "unique_username", :unique => true
  add_index "users", ["username"], :name => "user_username_idx"

  create_table "visit_medicines", :force => true do |t|
    t.integer "visit_id",                     :null => false
    t.integer "medicine_id",                  :null => false
    t.integer "units_given",                  :null => false
    t.decimal "discount",    :default => 0.0
  end

  add_index "visit_medicines", ["medicine_id"], :name => "visit_medicine_medicine_idx"
  add_index "visit_medicines", ["visit_id"], :name => "visit_medicine_visit_idx"

  create_table "visits", :force => true do |t|
    t.integer "pet_id",                        :null => false
    t.date    "date",                          :null => false
    t.integer "weight"
    t.boolean "overnight_stay"
    t.integer "total_charge",   :default => 0
  end

  add_index "visits", ["date"], :name => "visits_date_idx"
  add_index "visits", ["pet_id"], :name => "visits_pet_idx"

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
