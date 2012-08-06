class AddAttachmentAvaterToProducts < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.has_attached_file :avater
    end
  end

  def self.down
    drop_attached_file :products, :avater
  end
end
