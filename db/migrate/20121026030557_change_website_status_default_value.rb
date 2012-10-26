class ChangeWebsiteStatusDefaultValue < ActiveRecord::Migration
  def change
    change_column :websites, :status, :integer, :default => 2, :null => false
  end
end
