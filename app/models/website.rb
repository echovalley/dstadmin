class Website < ActiveRecord::Base
  require 'net/http'
  
  STATUS_VERIFIED = 1
  STATUS_NOTVERIFIED = 2

  attr_accessible :pv, :status, :url, :wcode, :wname, :website_category_id
  attr_accessor :tagged_images_number, :untagged_images_number, :spots_number, :total_income

  belongs_to :website_category

  has_many :tagged_images, :dependent => :destroy
  has_and_belongs_to_many :users, :join_table => 'websites_users'
  validates_presence_of :wcode, :wname, :status
  has_one :spot_statistics


  def update_website_code
    self.wcode = 'WS' + Utils.create_random_code(8)
  end

  #Search websites by user code
  def self.search_by_user(user_code, status = nil)
    if status.present?
      Website.includes(:users).where(:users => {:user_code => user_code, :user_type => User::TYPE_WEBSITE}, :status => status)
    else
      Website.includes(:users).where(:users => {:user_code => user_code, :user_type => User::TYPE_WEBSITE})
    end
  end

  #Count how many tagged images under website
  def count_tagged_images
    self.tagged_images_number = TaggedImage.where(:website_id => self.id).count(:id, :distinct => true)
  end

  #Count how many untagged images under website
  def count_untagged_images
    self.untagged_images_number = 0 #todo
  end

  #Count how many spots under website
  def count_spots
    self.spots_number = Spot.joins(:tagged_image).where(:tagged_images => {:website_id => self.id}).count(:id, :distinct => true)
  end

  #Count total income
  def count_total_income
    statistics = SpotStatistics.search(:website_id => self.id, :start_date => '2012-7-1'.to_date)
    totalincome = 0
    statistics.each do |t|
      totalincome += t.income
    end
    self.total_income = totalincome
  end

  #Assign website to user
  def add_user(user_code)
    user = User.find_by_user_code(user_code)
    if user.present?
      unless User.includes(:websites).where(:id => user.id, :user_type => User::TYPE_WEBSITE, :websites => {:id => self.id}).exists?
        self.users << user
      end
    end
  end

  #Check whether the website belong to user
  def check_permission(user_code)
    User.includes(:websites).where(:user_code => user_code, :user_type => User::TYPE_WEBSITE, :websites => {:id => self.id}).exists?
  end

  #Get verify file name
  def get_verify_filename
    wcode + created_at.strftime('%Y%m%d%H%M%S') + '.html'
  end

  #Get verify body
  def get_verify_body
    'ADSPOT_WEBSITE_CODE=' + wcode
  end

  def verify(url)
    domain = Utils.get_domain(url)
    return false unless Utils.belong_to_domain(domain, self.url)
    uri = URI(url)
    req = Net::HTTP.get(uri)
    return req.include?('ADSPOT_WEBSITE_CODE=' + wcode)
  end

  def verified
    status == STATUS_VERIFIED
  end

  def get_total_tagged_images_statistics
    impression = 0
    hover = 0
    TaggedImageStatistics.search_by_website(self.id).each do |t|
      impression += t.impression unless t.impression.blank?
      hover += t.hover unless t.hover.blank?
    end
    { :impression => impression, :hover => hover }
  end

  def get_total_spots_statistics
    impression = 0
    click = 0
    income = 0
    SpotStatistics.search(:website_id => self.id, :start_date => '2012-1-1'.to_date, :end_date => Date.today).each do |t|
      impression += t.impression unless t.impression.blank?
      click += t.click unless t.click.blank?
      income += t.income unless t.income.blank?
    end
    { :impression => impression, :click => click, :income => income }
  end

  def to_param
    wcode
  end

end
