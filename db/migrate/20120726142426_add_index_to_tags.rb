class AddIndexToTags < ActiveRecord::Migration
  def change  
    add_index "tags", "tname", :name => "idx_tname", :unique => true
  end
end
