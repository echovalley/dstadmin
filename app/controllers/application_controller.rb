class ApplicationController < ActionController::Base

  include SimpleCaptcha::ControllerHelpers

  before_filter :check_privilege
  skip_before_filter :check_privilege, :only => [:refresh_captcha]

  # GET /common/refresh_captcha
  def refresh_captcha
    respond_to do |format|
      format.js { render 'common/refresh_captcha' }
    end
  end

  def error
    respond_to do |format|
      format.html { render 'common/error' }
    end
  end

protected

  protect_from_forgery

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
