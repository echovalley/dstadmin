class Advertiser < ActiveRecord::Base
  attr_accessible :address, :code, :homepage, :mobile, :name, :open, :status, :tel, :zip
  has_and_belongs_to_many :users
  has_many :products, :dependent => :destroy

  validates_presence_of :name, :code, :status
end
