# encoding: utf-8
class UsersController < ApplicationController

  before_filter :check_current_user, :only => [:change_password, :update_password]
  before_filter :check_captcha, :only => [:reset_password]
  skip_before_filter :check_privilege, :only => [:signin, :signout, :authenticate, :forget_password, :reset_password]

  # GET /users/signin
  def signin
    respond_to do |format|
      @email = params[:email]
      format.html # signin.html.erb
    end
  end

  # GET /users/signout
  def signout
    reset_session
    respond_to do |format|
      format.html { redirect_to signin_users_path }
    end
  end

  # POST /users/signin
  def authenticate 
    r = User.verify(params[:email], params[:password])
    user = r[:user]
    login_status = r[:login_status]
    respond_to do |format|
      if login_status == User::SIGNIN_STATUS_SUCCESS
        reset_session
        session[:user] = user
        user.update_login_status(request.ip)
        if user.user_type == User::TYPE_ADVERTISER
          session[:curadv] = user.advertisers[0].id
          format.html { redirect_to dashboard_advertiser_path }
        else
          format.html { head :bad_request }
        end
      else
        if login_status == User::SIGNIN_STATUS_WRONG
          flash[:error] = '账号或密码不对'
        elsif login_status == User::SIGNIN_STATUS_FROZEN
          flash[:error] = '账号被冻结'
        else
          flash[:error] = '账号异常，目前不能登录'
        end
        format.html { redirect_to signin_users_path(:email => params[:email]) }
      end
    end
  end

  # GET /users/1/changepwd
  def change_password
    @user = User.find_by_user_code(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # PUT /users/1/changepwd
  def update_password
    r = User.verify(get_current_user.email, params[:old_password])
    user = r[:user]
    login_status = r[:login_status]

    respond_to do |format|
      if login_status == User::SIGNIN_STATUS_SUCCESS
        user.update_password(params[:new_password])
        user.save
        flash[:success] = '已改成新密码'
      else
        flash[:error] = '原密码错误，未修改'
      end
      format.html { redirect_to change_password_user_path }
    end
  end

  # GET /users/forgetpwd
  def forget_password
    respond_to do |format|
      format.html
    end
  end

  # PUT /users/forgetpwd
  def reset_password
    user = User.find_by_email(params[:email])
    respond_to do |format|
      if user.present?
        true_password = user.reset_password
        if user.save
          UserMailer.reset_password_email(user.email, true_password).deliver
          flash[:success] = '已将新密码发送至您的注册邮箱：' + user.email
          format.html { redirect_to signin_users_path } 
        else
          flash[:error] = '重置密码失败，请稍后重试'
          format.html { redirect_to :back } 
        end
      else
        flash[:error] = '注册邮箱有误'
        format.html { redirect_to :back } 
      end

    end
  end

  private

  def check_current_user
    unless params[:id] == get_current_user.user_code
      respond_to do |format|
        format.html { redirect_to signin_users_path } 
      end
    end
  end

  def check_captcha
    unless simple_captcha_valid?
      respond_to do |format|
        flash[:error] = '验证码错误'
        format.html { redirect_to :back } 
      end
    end
  end

end
