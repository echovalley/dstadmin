class ApplicationController < ActionController::Base

  include SimpleCaptcha::ControllerHelpers

protected

  protect_from_forgery

  before_filter :check_privilege

  def check_privilege
    if session[:user].blank?
      respond_to do |format|
        format.html { redirect_to signin_users_path }
      end
    end
  end

  def get_current_advertiser_id
    session[:curadv]
  end

  def get_current_user
    session[:user]
  end

end
