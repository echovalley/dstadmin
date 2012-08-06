class CreateAdvertisers < ActiveRecord::Migration
  def change
    create_table :advertisers do |t|
      t.string :code
      t.string :name
      t.string :homepage
      t.boolean :open
      t.string :address
      t.string :zip
      t.string :tel
      t.string :mobile
      t.integer :status

      t.timestamps
    end
  end
end
