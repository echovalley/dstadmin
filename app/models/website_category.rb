class WebsiteCategory < ActiveRecord::Base
  attr_accessible :wcname
  has_many :websites, :dependent => :destroy
  validates_presence_of :wcname

end
