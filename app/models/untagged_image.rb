class UntaggedImage < ActiveRecord::Base
  attr_accessible :access_status, :height, :remote_addr, :thumb, :title, :width, :locate_url
  belongs_to :website
  validates_presence_of :remote_addr, :width, :height

  def self.find_by_website(website_id, order_by = nil)
    if order_by.blank?
      UntaggedImage.where(:website_id => website_id)
    else
      UntaggedImage.where(:website_id => website_id).order(order_by)
    end
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
      UntaggedImage.find(:all, :conditions => ([conditions_str] + conditions_param))
    else
      UntaggedImage.find(:all, :conditions => ([conditions_str] + conditions_param), :order => options[:order_by])
    end
  end

end
