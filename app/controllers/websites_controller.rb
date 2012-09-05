# encoding: utf-8
class WebsitesController < ApplicationController

  before_filter :check_access_permission, :except => [:new, :index, :create]
  before_filter :current_user

  # GET /websites
  def index
    @websites = my_websites
    respond_to do |format|
      format.html
    end
  end

  # GET /websites/new
  def new
    @website = Website.new
    @websites = my_websites
    @website_categories = WebsiteCategory.all
    respond_to do |format|
      format.html { render 'properties' }
    end
  end

  # GET /websites/1/edit
  def edit
    @website = Website.find_by_wcode(params[:id])
    respond_to do |format|
      @websites = my_websites
      @website_categories = WebsiteCategory.all
      format.html { render @website.verified ? 'edit' : 'properties' }
    end
  end

  # POST /websites
  def create
    @website = Website.new(params[:website])

    respond_to do |format|
      if Website.find_by_url(@website.url).present?
        flash[:error] = '该域名已存在'
        format.html { redirect_to :back }
      else
        @website.status = Website::STATUS_NOTVERIFIED
        @website.update_website_code
        @website.save
        @website.add_user(get_current_user)
        format.html { redirect_to :action => 'pre_verify', :id => @website.wcode }
      end
    end
  end

  # PUT /websites/1
  def update
    @website = Website.find_by_wcode(params[:id])
    @website.status = Website::STATUS_NOTVERIFIED if params[:website][:url].present? && @website.url != params[:website][:url]
    @website.update_attributes(params[:website])

    respond_to do |format|
      if @website.verified
        flash[:success] = '网站资料已保存'
        format.html { redirect_to :action => 'edit', :id => @website.wcode }
      else
        format.html { redirect_to :action => 'pre_verify', :id => @website.wcode }
      end
    end
  end

  # DELETE /websites/1
  def destroy
    website = Website.find_by_wcode(params[:id])
    respond_to do |format|
      if website.delete
        flash[:success] = '已删除'
      else
        flash[:error] = '删除失败'
      end
        format.html { redirect_to :action => 'index' }
    end
  end

  # GET /websites/1/pre_verify
  def pre_verify
    @website = Website.find_by_wcode(params[:id])
    @websites = my_websites

    respond_to do |format|
      format.html { render 'verify' }
    end
  end

  # POST /websites/1/verify
  def verify
    @website = Website.find_by_wcode(params[:id])
    target_url = params[:url].blank?? @website.url : params[:url]

    respond_to do |format|
      if @website.verify(target_url)
        @website.status = Website::STATUS_VERIFIED
        @website.save
        flash[:success] = '验证通过！'
        format.html { redirect_to code_website_path(@website.wcode) }
      else
        @websites = my_websites
        flash[:error] = '验证失败'
        format.html { redirect_to :back }
      end
    end
  end

  # GET /websites/1/create_verify_file
  def create_verify_file
    website = Website.find_by_wcode(params[:id])
    send_data(website.get_verify_body, :filename => website.get_verify_filename)
  end

  # GET /websites/1/code
  def code 
    @website = Website.find_by_wcode(params[:id])

    respond_to do |format|
      if @website.verified
        @websites = my_websites
        format.html { render 'code' }
      else
        format.html { redirect_to error_path } 
      end
    end
  end


  protected 

  #Search all websites already pass verification
  def my_websites
    Website.search_by_user(get_current_user)
  end

  def check_access_permission
    website = Website.find_by_wcode(params[:id])
    unless website.present? && website.check_permission(get_current_user)
      respond_to do |format|
        format.html { redirect_to error_path } 
      end
    end
  end

  def current_user
    @user = get_current_user
  end

end
