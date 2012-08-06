class CreateSpotStatistics < ActiveRecord::Migration
  def change
    create_table :spot_statistics do |t|
      t.integer :spot_id, :null => false
      t.date :log_date, :null => false
      t.integer :impression, :null => false, :default => 0
      t.integer :click, :null => false, :default => 0
      t.integer :income, :null => false, :default => 0
    end

    add_index 'spots', 'type', :name => 'idx_type'
    add_index 'spots', 'tagged_image_id', :name => 'idx_tagged_image_id'
    add_index 'spots', 'product_id', :name => 'idx_product_id'
  end
end
