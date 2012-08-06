class ChangeTypeFromSpots < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      rename_column :spots, :type, :spot_type
      add_column :tagged_images, :locate_url, :string
    end
  end
end
