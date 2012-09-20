class TaggedImage < ActiveRecord::Base
  attr_accessible :access_status, :height, :remote_addr, :spot_by_adv, :spot_by_adv_rule, :thumb, :title, :width, :locate_url
  attr_accessor :spots_number
  belongs_to :website
  has_many :spots, :dependent => :destroy
  has_many :tagged_image_statistics
  validates_presence_of :remote_addr, :width, :height

  def self.find_by_product(product_id)
    TaggedImage.joins(:spots => :product).where(:products => {:id => product_id}, :spots => {:spot_type => Spot::TYPE_PRODUCT})
  end

  def self.find_by_website(website_id, order_by = nil)
    if order_by.blank?
      TaggedImage.where(:website_id => website_id)
    else
      TaggedImage.where(:website_id => website_id).order(order_by)
    end
  end

  #Count how many spots under tagged_images 
  def count_spots(spot_type = nil)
    self.spots_number = spot_type.blank?? Spot.where(:tagged_image_id => self.id).count(:id, :distinct => true) 
    : Spot.where(:tagged_image_id => self.id, :spot_type => spot_type).count(:id, :distinct => true)
  end

  def self.search(options = {})
    conditions_string = [];
    conditions_param = [];
    website_id = options[:website_id]
    unless website_id.blank?
      conditions_string << "website_id = ?"
      conditions_param << website_id
    end
    keyword = options[:keyword]
    if keyword.present?
      conditions_string << "(title like ?)"
      conditions_param << "%#{keyword}%"
    end

    conditions_str = conditions_string.join(" AND ") unless conditions_string.blank?
    if options[:order_by].blank?
      TaggedImage.find(:all, :conditions => ([conditions_str] + conditions_param))
    else
      TaggedImage.find(:all, :conditions => ([conditions_str] + conditions_param), :order => options[:order_by])
    end
  end

  def get_linked_products
    Product.joins(:spots).where(:spots => {:tagged_image_id => self.id, :spot_type => Spot::TYPE_PRODUCT}, :status => Product::STATUS_ACTIVE).uniq
  end

  def self.get_website_id_by_spot(spot_id)
    image = TaggedImage.includes(:spots).where(:spots => {:id => spot_id}).first
    image.website_id
  end

end
