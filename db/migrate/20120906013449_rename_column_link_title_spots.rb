class RenameColumnLinkTitleSpots < ActiveRecord::Migration
  def change
    rename_column :spots, :link__title, :link_title
  end
end
