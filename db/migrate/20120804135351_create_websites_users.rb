class CreateWebsitesUsers < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      create_table :websites_users do |t|
        t.integer :website_id, :null => false
        t.integer :user_id, :null => false
      end

      add_index "websites_users", ["website_id", "user_id"], :name => "by_website_and_user", :unique => true
    end
  end
end
