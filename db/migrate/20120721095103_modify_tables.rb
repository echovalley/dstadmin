class ModifyTables < ActiveRecord::Migration
  def change
    change_column :advertisers, :code, :string, :limit => 10, :null => false
    change_column :advertisers, :name, :string, :limit => 100, :null => false
    change_column :advertisers, :open, :boolean, :null => false, :default => true
    change_column :advertisers, :zip, :string, :limit => 20
    change_column :advertisers, :tel, :string, :limit => 20
    change_column :advertisers, :mobile, :string, :limit => 20
    change_column :advertisers, :status, :integer, :null => false, :default => 1

    change_column :users, :user_code, :string, :limit => 10, :null => false
    change_column :users, :email, :string, :limit => 50, :null => false
    change_column :users, :password, :string, :limit => 50, :null => false
    change_column :users, :login_count, :integer, :null => false, :default => 0
    change_column :users, :login_ip, :string, :limit => 20
    change_column :users, :user_type, :integer, :null => false
    change_column :users, :status, :integer, :null => false, :default => 1

    drop_table :advertiser_users

    create_table :advertisers_users, :id=>false do |t|
      t.integer :advertiser_id, :null => false
      t.integer :user_id, :null => false
    end

    add_index :advertisers_users, [ :advertiser_id, :user_id ], :unique => true, :name => 'by_advertiser_and_user'

    change_column :products, :pcode, :string, :limit => 10, :null => false
    change_column :products, :pname, :string, :limit => 100, :null => false
    change_column :products, :brand, :string, :limit => 50
    change_column :products, :pdct_price, :decimal, :precision => 9, :scale => 2, :null => false, :default => 0.00
    change_column :products, :unit_price, :decimal, :precision => 9, :scale => 2, :null => false, :default => 0.00
    change_column :products, :upper_limit, :decimal, :precision => 9, :scale => 2, :null => false, :default => 0.00
    change_column :products, :pricing, :integer, :null => false, :default => 1
    change_column :products, :click_target, :string, :null => false
    change_column :products, :delivery_type, :integer, :null => false, :default => 1
    change_column :products, :status, :integer, :null => false, :default => 1

    add_index :products_tags, [ :product_id, :tag_id ], :unique => true, :name => 'by_product_and_tag'
  end
end
