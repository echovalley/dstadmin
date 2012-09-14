# encoding: utf-8
class UsersController < ApplicationController

  before_filter :check_current_user, :only => [:change_password, :update_password]
  before_filter :check_captcha, :only => [:reset_password, :signup_submit]
  skip_before_filter :check_privilege, :except => [:change_password, :update_password]

  # GET /users/signup
  def signup
    respond_to do |format|
      @email = params[:email]
      format.html # signup.html.erb
    end
  end

  # GET /users/check_email
  def check_email
    respond_to do |format|
      format.html do
        if User.find_by_email(params[:email])
          render :text => 'false'
        else
          render :text => 'true'
        end
      end
    end
  end


  # POST /users/signup_submit
  def signup_submit
    user = User.find_by_email(params[:email])
    respond_to do |format|
      if user.blank?
        user = User.new
        user.email = params[:email]
        user.update_password(params[:password])
        user.initialize_website_user
        user.save
        if user.save
          @email = user.email
          UserMailer.activation_email(user.email, activate_users_url + '?code=' + user.activation_code).deliver
          format.html { render 'signup_ok' } 
        else
          flash[:error] = '账号创建失败，请稍后重试'
          format.html { redirect_to :back } 
        end
      else
        flash[:error] = '该账户已经存在'
        #format.html { redirect_to signin_users_path(:email => params[:email]) }
        format.html { redirect_to :back, :email => params[:email] }
      end
    end
  end

  # GET /users/activate
  def activate
    user = User.find_by_activation_code(params[:code])
    if user.present? && user.status == User::STATUS_UNACTIVE
      user.update_attributes(:status => User::STATUS_ACTIVE)
      @success = 1
    end
    respond_to do |format|
      format.html
    end
  end

  # GET /users/send_activation_email
  def send_activation_email
    user = User.find_by_email(params[:email])
    if user.present?
      user.update_activation_code
      user.save
      UserMailer.activation_email(user.email, activate_users_url + '?code=' + user.activation_code).deliver
      flash[:success] = '已发出验证码'
      @email = params[:email]
    else
      flash[:error] = '无此用户'
    end
    format.html
  end

  # GET /users/signup_adv
  def signup_adv
    respond_to do |format|
      format.html # signup_adv.html.erb
    end
  end

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
    cookies.delete :u, :domain => Utils.get_main_domain(request.host) || 'adspot.cn'
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
        session[:user] = user.user_code
        session[:user_email] = user.email
        cookies[:u] = {
          :value => user.user_code,
          :expires => 1.hour.from_now,
          :domain => Utils.get_main_domain(request.host) || 'adspot.cn'
        }
        user.update_login_status(request.ip)
        if user.user_type == User::TYPE_ADVERTISER
          session[:curadv] = user.advertisers[0].id
          format.html { redirect_to dashboard_advertiser_path }
        elsif user.user_type == User::TYPE_WEBSITE
          format.html { redirect_to websites_path }
        else
          format.html { head :bad_request }
        end
      else
        if login_status == User::SIGNIN_STATUS_WRONG
          flash[:error] = '账号或密码不对'
        elsif login_status == User::SIGNIN_STATUS_FROZEN
          flash[:error] = '账号被冻结'
        elsif login_status == User::SIGNIN_STATUS_UNACTIVE
          flash[:error] = '账号还没有激活'
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
    r = User.verify(User.find_by_user_code(get_current_user).email, params[:old_password])
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
    unless params[:id] == get_current_user
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
