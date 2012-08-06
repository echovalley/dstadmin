class Website < ActiveRecord::Base
  attr_accessible :pv, :status, :url, :wcode, :wname
  belongs_to :website_category
  has_many :tagged_images, :dependent => :destroy
  has_and_belongs_to_many :users
  validates_presence_of :wcode, :wname, :status

  def update_website_code
    self.wcode = 'WS' + Utils.create_random_code(8)
  end

  def to_param
    wcode
  end
end
