class User < ActiveRecord::Base
  TYPE_ADVERTISER = 1
  TYPE_WEBSITE = 2

  STATUS_ACTIVE = 1
  STATUS_FROZEN = 2

  SIGNIN_STATUS_SUCCESS = 1
  SIGNIN_STATUS_WRONG = 2
  SIGNIN_STATUS_FROZEN = 4
  SIGNIN_STATUS_EXCEPTION = 9

  attr_accessible :email, :login_count, :login_ip, :password, :status, :user_code, :user_type, :advertisers, :websites
  has_and_belongs_to_many :advertisers, :join_table => 'advertisers_users'
  has_and_belongs_to_many :websites, :join_table => 'websites_users'
  validates_presence_of :email, :password, :user_type, :user_code, :status
  validates_uniqueness_of :email, :user_code

  def self.verify(email, password)
    user = User.where(:email => email, :password => Utils.sha1(password + 'ad2012spot' + email)).includes(:advertisers, :websites).first
    login_status = nil
    if user.present?
      if user.status == STATUS_ACTIVE
        login_status = SIGNIN_STATUS_SUCCESS 
      else
        login_status = SIGNIN_STATUS_FROZEN
      end
    else
      login_status = SIGNIN_STATUS_WRONG
    end
    {:user => user, :login_status => login_status}
  end

  def update_login_status(ip)
    self.login_ip = ip 
    self.login_count += 1
    self.save
  end

  def update_user_code
    self.user_code = 'US' + Utils.create_random_code(8)
  end

  def update_password(newpwd)
    self.password = Utils.sha1(newpwd + 'ad2012spot' + email)
  end

  def reset_password
    true_password = Utils.create_random_code(10)
    self.password = self.update_password(true_password)
    return true_password
  end

  def to_param
    user_code
  end

  private

end
