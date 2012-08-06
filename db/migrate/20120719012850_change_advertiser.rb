class ChangeAdvertiser < ActiveRecord::Migration
  def change
    change_column :advertisers, :status, :integer, :default => 0
    change_column :advertisers, :open, :boolean, :default => true
  end
end
