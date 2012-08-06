# encoding: utf-8
class UsersController < ApplicationController

  # GET /users/1
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
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
    respond_to do |format|
      format.html { redirect_to signin_users_path }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users/signin
  def authenticate 
    r = User.verify(params[:email], params[:password], request.ip)
    user = r[:user]
    login_status = r[:login_status]
    respond_to do |format|
      if login_status == User::SIGNIN_STATUS_SUCCESS
        reset_session
        session[:ucode] = user.user_code
        if user.user_type == User::TYPE_ADVERTISER
          session[:curadv] = user.advertisers[0].id
          format.html { redirect_to '/products' }
        else
          format.html { head :bad_request }
        end
      else
        if login_status == User::SIGNIN_STATUS_WRONG
          notice = '账号或密码不对'
        elsif login_status == User::SIGNIN_STATUS_FROZEN
          notice = '账号被冻结'
        else
          notice = '账号异常，目前不能登录'
        end
        flash[:notice] = notice 
        format.html { redirect_to signin_users_path(:email => params[:email]) }
      end
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    #@user.destroy

    respond_to do |format|
      format.html { render :nothing }
    end
  end
end
