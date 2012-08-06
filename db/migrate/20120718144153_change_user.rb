class ChangeUser < ActiveRecord::Migration
  def change
    change_column :users, :login_count, :integer, :default => 0
  end
end
