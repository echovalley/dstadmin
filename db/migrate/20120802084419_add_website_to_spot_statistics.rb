class AddWebsiteToSpotStatistics < ActiveRecord::Migration
  def change
    add_column :spot_statistics, :website_id, :integer, :null => false
    add_column :spot_statistics, :product_id, :integer, :null => false, :default => 0
  end
end
