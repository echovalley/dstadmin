class RemoveCrtTimeFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :ctr_time
  end

  def down
    add_column :users, :ctr_time, :datetime
  end
end
