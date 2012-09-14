class Spot < ActiveRecord::Base
  attr_accessible :link_title, :link_addr, :link_css, :link_desc, :link_thumb, :margin_x, :margin_y, :search_tag, :spot_type
  belongs_to :tagged_image
  belongs_to :product
  has_one :spot_statistics
  TYPE_PRODUCT = 1
  TYPE_LINK = 2
end
