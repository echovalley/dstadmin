class User < ActiveRecord::Base
  TYPE_ADVERTISER = 1
  TYPE_WEBSITE = 2

  STATUS_ACTIVE = 1
  STATUS_FROZEN = 2
  STATUS_UNACTIVE = 3

  SIGNIN_STATUS_SUCCESS = 1
  SIGNIN_STATUS_WRONG = 2
  SIGNIN_STATUS_FROZEN = 4
  SIGNIN_STATUS_UNACTIVE = 5
  SIGNIN_STATUS_EXCEPTION = 9

  attr_accessible :email, :login_count, :login_ip, :password, :status, :user_code, :user_type, :advertisers, :websites, :activation_code
  has_and_belongs_to_many :advertisers, :join_table => 'advertisers_users'
  has_and_belongs_to_many :websites, :join_table => 'websites_users'
  validates_presence_of :email, :password, :user_type, :user_code, :status
  validates_uniqueness_of :email, :user_code

  # Verify login information from controller
  def self.verify(email, password)
    user = User.where(:email => email, :password => Utils.sha1(password.to_s + 'ad2012spot' + email)).includes(:advertisers, :websites).first
    login_status = nil
    if user.present?
      if user.status == STATUS_ACTIVE
        login_status = SIGNIN_STATUS_SUCCESS 
      elsif user.status == STATUS_FROZEN
        login_status = SIGNIN_STATUS_FROZEN
      else
        login_status = SIGNIN_STATUS_UNACTIVE
      end
    else
      login_status = SIGNIN_STATUS_WRONG
    end
    {:user => user, :login_status => login_status}
  end

  # Record last login ip and increase login times
  def update_login_status(ip)
    self.login_ip = ip 
    self.login_count += 1
    self.save
  end

  # Generate user code
  def update_user_code
    self.user_code = 'US' + Utils.create_random_code(8)
  end

  # Update password by input
  def update_password(newpwd)
    self.password = Utils.sha1(newpwd + 'ad2012spot' + email)
  end

  # Update random password
  def reset_password
    true_password = Utils.create_random_code(10)
    self.password = self.update_password(true_password)
    return true_password
  end

  # Update activation_code 
  def update_activation_code
    self.activation_code = Utils.sha1(Time.now.to_s + 'ad2012spot' + self.email)
    return self.activation_code
  end

  # Initialize website-type user status
  def initialize_website_user
    self.user_type = TYPE_WEBSITE
    self.update_user_code
    self.update_activation_code
    self.status = STATUS_UNACTIVE
  end

  # Initialize advertiser-type user status
  def initialize_advertiser_user
    self.user_type = TYPE_ADVERTISER
    self.update_user_code
    self.status = STATUS_ACTIVE
  end

  def to_param
    user_code
  end

  private

end
