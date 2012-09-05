class CreateTaggedImageStatistics < ActiveRecord::Migration
  def change
    create_table :tagged_image_statistics do |t|
      t.integer "tagged_image_id",           :null => false
      t.date    "log_date",                  :null => false
      t.integer "impression", :default => 0, :null => false
      t.integer "click",      :default => 0, :null => false
      t.integer "hover",      :default => 0, :null => false
    end
  end
end
