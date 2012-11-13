class ChangeColumnOffsetRatio < ActiveRecord::Migration
  def change
    change_column :spots, :x_offset_ratio, :decimal, :precision => 5, :scale => 4, :default => 0.5, :null => false
    change_column :spots, :y_offset_ratio, :decimal, :precision => 5, :scale => 4, :default => 0.5, :null => false
  end
end
