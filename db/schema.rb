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

ActiveRecord::Schema.define(:version => 20120810202535) do

  create_table "advertisers", :force => true do |t|
    t.string   "code",       :limit => 10,                    :null => false
    t.string   "name",       :limit => 100,                   :null => false
    t.string   "homepage"
    t.boolean  "open",                      :default => true, :null => false
    t.string   "address"
    t.string   "zip",        :limit => 20
    t.string   "tel",        :limit => 20
    t.string   "mobile",     :limit => 20
    t.integer  "status",                    :default => 1,    :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "advertisers_users", :id => false, :force => true do |t|
    t.integer "advertiser_id", :null => false
    t.integer "user_id",       :null => false
  end

  add_index "advertisers_users", ["advertiser_id", "user_id"], :name => "by_advertiser_and_user", :unique => true

  create_table "products", :force => true do |t|
    t.string   "pcode",               :limit => 10,                                                 :null => false
    t.string   "pname",               :limit => 100,                                                :null => false
    t.string   "brand",               :limit => 50
    t.text     "description"
    t.decimal  "pdct_price",                         :precision => 9, :scale => 2, :default => 0.0, :null => false
    t.decimal  "upper_limit",                        :precision => 9, :scale => 2, :default => 0.0, :null => false
    t.integer  "pricing",                                                          :default => 1,   :null => false
    t.string   "pdct_thumb"
    t.string   "click_target",                                                                      :null => false
    t.integer  "delivery_type",                                                    :default => 1,   :null => false
    t.text     "delivery_rule"
    t.integer  "status",                                                           :default => 1,   :null => false
    t.integer  "advertiser_id",                                                                     :null => false
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.decimal  "unit_price",                         :precision => 9, :scale => 2, :default => 0.0, :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "products_tags", :id => false, :force => true do |t|
    t.integer "product_id", :null => false
    t.integer "tag_id",     :null => false
  end

  add_index "products_tags", ["product_id", "tag_id"], :name => "by_product_and_tag", :unique => true

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "spot_statistics", :force => true do |t|
    t.integer "spot_id",                   :null => false
    t.date    "log_date",                  :null => false
    t.integer "impression", :default => 0, :null => false
    t.integer "click",      :default => 0, :null => false
    t.integer "income",     :default => 0, :null => false
    t.integer "website_id",                :null => false
    t.integer "product_id", :default => 0, :null => false
  end

  create_table "spots", :force => true do |t|
    t.integer  "spot_type",                                      :null => false
    t.integer  "tagged_image_id",                                :null => false
    t.integer  "margin_x",                       :default => 0,  :null => false
    t.integer  "margin_y",                       :default => 0,  :null => false
    t.string   "link_addr"
    t.string   "link__title",     :limit => 100, :default => ""
    t.string   "link_desc"
    t.string   "link_thumb"
    t.string   "link_css",        :limit => 10
    t.integer  "product_id",                     :default => 0
    t.string   "search_tag"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "spots", ["product_id"], :name => "idx_product_id"
  add_index "spots", ["spot_type"], :name => "idx_type"
  add_index "spots", ["tagged_image_id"], :name => "idx_tagged_image_id"

  create_table "tagged_images", :force => true do |t|
    t.integer  "website_id",                                         :null => false
    t.string   "remote_addr"
    t.string   "title",            :limit => 100
    t.integer  "width",                                              :null => false
    t.integer  "height",                                             :null => false
    t.boolean  "thumb",                           :default => false, :null => false
    t.integer  "access_status",                   :default => 1,     :null => false
    t.boolean  "spot_by_adv",                     :default => false, :null => false
    t.string   "spot_by_adv_rule"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "locate_url"
  end

  add_index "tagged_images", ["website_id"], :name => "idx_website_id"

  create_table "tags", :force => true do |t|
    t.string "tname", :limit => 50, :null => false
  end

  add_index "tags", ["tname"], :name => "idx_tname", :unique => true

  create_table "users", :force => true do |t|
    t.string   "user_code",   :limit => 10,                 :null => false
    t.string   "email",       :limit => 50,                 :null => false
    t.string   "password",    :limit => 50,                 :null => false
    t.integer  "login_count",               :default => 0,  :null => false
    t.string   "login_ip",    :limit => 20, :default => ""
    t.integer  "user_type",                                 :null => false
    t.integer  "status",                    :default => 1,  :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "website_categories", :force => true do |t|
    t.string   "wcname",     :limit => 100, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "websites", :force => true do |t|
    t.string   "wcode",               :limit => 10,                 :null => false
    t.string   "wname",               :limit => 100,                :null => false
    t.string   "url",                                               :null => false
    t.integer  "pv",                                 :default => 1, :null => false
    t.integer  "website_category_id",                               :null => false
    t.integer  "status",                             :default => 1, :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "websites", ["status"], :name => "idx_status"
  add_index "websites", ["wcode"], :name => "idx_wcode"
  add_index "websites", ["website_category_id"], :name => "idx_wc_id"

  create_table "websites_users", :force => true do |t|
    t.integer "website_id", :null => false
    t.integer "user_id",    :null => false
  end

  add_index "websites_users", ["website_id", "user_id"], :name => "by_website_and_user", :unique => true

end
