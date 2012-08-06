class ChangeColumns < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      add_index 'websites', 'wcode', :name => 'idx_wcode'
      change_column :tagged_images, :thumb, :boolean, :default => false
      change_column :tagged_images, :spot_by_adv, :boolean, :default => false
      change_column :tagged_images, :access_status, :integer, :default => 1
    end
  end
end
