# encoding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "AdSpot <tony.tong@uniqlick.com>"

  def reset_password_email(email, new_password)
    @password = new_password
    @url  = signin_users_url
    mail(:to => email, :subject => "密码重置")
  end
end
