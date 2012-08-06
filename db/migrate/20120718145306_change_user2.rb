class ChangeUser2 < ActiveRecord::Migration
  def change 
    change_column :users, :status, :integer, :default => 0
    change_column :users, :login_ip, :string, :default => ''
  end
end
