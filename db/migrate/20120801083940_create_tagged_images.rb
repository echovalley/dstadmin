class CreateTaggedImages < ActiveRecord::Migration
  def change
    create_table :tagged_images do |t|
      t.integer :website_id, :null => false
      t.string :remote_addr
      t.string :title, :limit => 100
      t.integer :width, :null => false
      t.integer :height, :null => false
      t.integer :thumb, :null => false
      t.integer :access_status, :null => false
      t.integer :spot_by_adv, :null => false
      t.string :spot_by_adv_rule

      t.timestamps
    end

  end
end
