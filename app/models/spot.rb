class Spot < ActiveRecord::Base
  attr_accessible :link_title, :link_addr, :link_css, :link_desc, :link_thumb, :search_tag, :spot_type, :x_offset_ratio, :y_offset_ratio
  belongs_to :tagged_image
  belongs_to :product
  has_one :spot_statistics
  TYPE_PRODUCT = 1
  TYPE_LINK = 2
  
  def get_website_id
    image = TaggedImage.includes(:spots).where(:spots => {:id => self.id}).first
    image.website_id
  end
end
