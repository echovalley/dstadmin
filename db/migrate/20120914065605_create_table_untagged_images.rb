class CreateTableUntaggedImages < ActiveRecord::Migration
  def change
    create_table "untagged_images", :force => true do |t|
      t.integer  "website_id",                                         :null => false
      t.string   "remote_addr"
      t.string   "title",            :limit => 100
      t.integer  "width",                                              :null => false
      t.integer  "height",                                             :null => false
      t.boolean  "thumb",                           :default => false, :null => false
      t.integer  "access_status",                   :default => 1,     :null => false
      t.datetime "created_at",                                         :null => false
      t.datetime "updated_at",                                         :null => false
      t.string   "locate_url"
    end
  end
end
