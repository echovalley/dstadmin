class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_code
      t.string :email
      t.string :password
      t.integer :login_count
      t.string :login_ip
      t.integer :user_type
      t.integer :status

      t.timestamps
    end
  end
end
