class RenameUcode < ActiveRecord::Migration
  def change
    rename_column :users, :ucode, :user_code
    rename_column :users, :utype, :user_type
  end
end
