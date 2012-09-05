class AddActiveUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activation_code, :string, :limit => 40
  end
end
