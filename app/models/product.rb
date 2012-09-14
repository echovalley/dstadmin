class Product < ActiveRecord::Base
  default_scope :order => 'updated_at DESC'
  STATUS_ACTIVE = 1 #If refer outerside, use Product::STATUS_ACTIVE
  STATUS_PAUSED = 2

  attr_accessible :brand, :click_target, :delivery_rule, :delivery_type, :description, :pcode, :pdct_price, :unit_price, :pdct_thumb, :pname, :pricing, :status, :upper_limit, :avatar
  has_attached_file :avatar, 
    :default_style => :thumb,
    :styles => { :medium => "300x300#", :thumb => "100x100#" },
    :url => '/upload/:class/:id/:style/:hash.:extension',
    :hash_secret => 'aaa111'
    
  has_and_belongs_to_many :tags
  belongs_to :advertiser
  has_many :spots

  validates_presence_of :pname, :pricing, :unit_price, :pdct_price, :delivery_type, :click_target, :advertiser
  validates :pcode, :uniqueness => true
  validates_attachment :avatar, :content_type => { :content_type => ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }, :size => { :in => 0..1.megabytes }

  #after_post_process :set_thumb_path

  def self.list(advertiser_id)
    #todo: User the first client as default client
    search(:advertiser_id => advertiser_id)
  end

  def self.search(options={})
    conditions_string = [];
    conditions_param = [];
    advertiser_id = options[:advertiser_id]
    unless advertiser_id.blank?
      conditions_string << "advertiser_id = ?"
      conditions_param << advertiser_id
    end
    status = options[:status]
    if status.present? && status.to_i != -1
      conditions_string << "status = ?"
      conditions_param << status
    end
    keyword = options[:keyword]
    if keyword.present?
      conditions_string << "(pname like ? or brand like ?)"
      2.times.each { conditions_param << "%#{keyword}%" }
    end

    conditions_str = conditions_string.join(" AND ") unless conditions_string.blank?
    Product.find(:all, :conditions => ([conditions_str] + conditions_param))
  end

  def update_product_code
    self.pcode = 'PD' + Utils.create_random_code(8)
  end

  def to_param
    pcode
  end

  def toggle_status
    if self.status == STATUS_ACTIVE
      self.status = STATUS_PAUSED
    else
      self.status = STATUS_ACTIVE
    end
  end

  #Count how many products have been linked to spots
  def self.count_products_spotted_by_advertiser(advertiser_id)
    Product.joins(:spots).where(:advertiser_id => advertiser_id).count(:id, :distinct => true)
  end

  def self.count_products_by_advertiser(advertiser_id)
    Product.where(:advertiser_id => advertiser_id).count
  end

  def update_product_thumb
    if self.avatar.present?
      self.pdct_thumb = $1 if self.avatar.url =~ /^(.+)\?\d+$/
    end
  end

  #private

end
