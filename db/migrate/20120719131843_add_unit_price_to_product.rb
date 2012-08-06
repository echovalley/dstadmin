class AddUnitPriceToProduct < ActiveRecord::Migration
  def change
    add_column :products, :unit_price, :decimal, :default => 0
  end
end
