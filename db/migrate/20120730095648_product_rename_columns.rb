class ProductRenameColumns < ActiveRecord::Migration
  def change
    rename_column :products, :avater_file_name, :avatar_file_name
    rename_column :products, :avater_content_type, :avatar_content_type
    rename_column :products, :avater_file_size, :avatar_file_size
    rename_column :products, :avater_updated_at, :avatar_updated_at
  end
end
