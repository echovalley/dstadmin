class TaggedImage < ActiveRecord::Base
  attr_accessible :access_status, :height, :remote_addr, :spot_by_adv, :spot_by_adv_rule, :thumb, :title, :width, :locate_url
  belongs_to :website
  has_many :spots, :dependent => :destroy
  validates_presence_of :remote_addr, :width, :height

  def self.find_by_product(product_id)
    TaggedImage.joins(:spots => :product).where(:products => {:id => product_id}, :spots => {:spot_type => Spot::TYPE_PRODUCT})
  end
end
