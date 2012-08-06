class CreateWebsiteCategories < ActiveRecord::Migration
  def change
    create_table :website_categories do |t|
      t.string :wcname, :limit => 100, :null => false
      t.timestamps
    end
  end
end
