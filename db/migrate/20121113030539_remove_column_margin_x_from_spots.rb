class RemoveColumnMarginXFromSpots < ActiveRecord::Migration
  def change
    remove_column :spots, :margin_x
    remove_column :spots, :margin_y
  end
end
