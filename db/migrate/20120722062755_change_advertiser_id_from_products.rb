class ChangeAdvertiserIdFromProducts < ActiveRecord::Migration
  def change 
    change_column :products, :advertiser_id, :integer, :null => false

    Product.update_all(:advertiser_id => Advertiser.first.id)
  end
end
