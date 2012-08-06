class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :pcode
      t.string :pname
      t.string :brand
      t.text :description
      t.decimal :pdct_price, :default => 0
      t.decimal :upper_limit, :default => 0
      t.integer :pricing, :default => 0
      t.string :pdct_thumb
      t.string :click_target
      t.integer :delivery_type
      t.text :delivery_rule
      t.integer :status, :default => 1
      t.references :advertiser
      t.timestamps
    end
  end
end
