class WebsiteCategory < ActiveRecord::Base
  attr_accessible :wcname
  has_many :websites, :dependent => :destroy
  accepts_nested_attributes_for :websites
  validates_presence_of :wcname

end
