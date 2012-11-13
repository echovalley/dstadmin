class AddZoomRatioToTaggedImages < ActiveRecord::Migration
  def change
    add_column :spots, :x_offset_ratio, :decimal, :precision => 7, :scale => 4, :default => 1, :null => false
    add_column :spots, :y_offset_ratio, :decimal, :precision => 7, :scale => 4, :default => 1, :null => false
  end
end
