# encoding: utf-8
class ProductsController < ApplicationController

  ROWS_PRE_PAGE = 5;
  @current_advertiser_id

  before_filter :check_privilege


  # GET /products
  def index
    @products = Product.list(@current_advertiser_id).paginate :page => params[:page], :per_page => ROWS_PRE_PAGE
    @total_number = get_products_total_number @current_advertiser_id
    @spotted_number = get_products_spotted_number @current_advertiser_id

    respond_to do |format|
      format.html # index.html.erb
      format.js #index.js.erb
    end
  end

  # GET /products/1
  def show
    #@product = Product.find(params[:id])
    @product = Product.find_by_pcode(params[:id])
    @tagged_images = TaggedImage.find_by_product(@product.id)

    end_date = Date.today
    start_date = end_date - 7
    get_product_statistics(@product.id, start_date, end_date, 'log_date')

    respond_to do |format|
      format.js # show.js.erb
    end
  end

  # GET /products/new
  def new
    @product = Product.new

    respond_to do |format|
      format.js #new.js.erb
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find_by_pcode(params[:id])

    respond_to do |format|
      format.js #edit.js.erb
    end
  end

  # POST /products
  def create
    @product = Product.new(params[:product])
    @product.update_product_code
    @product.advertiser_id = @current_advertiser_id 
    @product.tags = Tag.get_tags(params[:tags])

    respond_to do |format|
      if @product.save
        format.js { redirect_to :action => 'upload', :id => @product.pcode, notice: 'Product was created' }
      else
        format.js { render 'new' }
      end
    end
  end

  # PUT /products/1
  def update
    @product = Product.find_by_pcode(params[:id])
    @product.tags = Tag.get_tags(params[:tags])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.js { redirect_to @product, notice: 'Product was successfully updated.' }
      else
        format.js { render 'edit' }
      end
    end
  end

  # DELETE /products/1
  def destroy
    @product = Product.find_by_pcode(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
    end
  end

  # POST /products/search
  def search
    params[:advertiser_id] = @current_advertiser_id
    @products = Product.search(params).paginate :page => params[:page], :per_page => ROWS_PRE_PAGE
    
    @keyword = params[:keyword]
    @status = params[:status]
    @total_number = get_products_total_number @current_advertiser_id
    @spotted_number = get_products_spotted_number @current_advertiser_id

    respond_to do |format|
      format.js { render 'search' }
    end
  end

  # POST /products/batch_destroy
  def batch_destroy
    pids = params[:pid]
    pids.each do |t|
      product = Product.find(t)
      product.destroy if product.present? && product.advertiser_id == @current_advertiser_id
    end

    respond_to do |format|
      format.js { redirect_to :action => :index }
      #format.html {redirect_to products_url }
    end
  end

  # POST /products/batch_update_status
  def batch_update_status
    pids = params[:pid]
    pids.each do |t|
      product = Product.find(t)
      if product.present? && product.advertiser_id == @current_advertiser_id && product.status != params[:status]
        product.status = params[:status]
        product.save
      end
    end

    respond_to do |format|
      format.js { redirect_to :action => :index }
    end
  end

  # POST /products/batch_update_tags
  def batch_update_tags
    pids = params[:pid]
    tags = Tag.get_tags(params[:tags])
    pids.each do |t|
      product = Product.find(t)
      if product.present? && product.advertiser_id == @current_advertiser_id
        product.tags = tags
        product.save
      end
    end

    respond_to do |format|
      format.js { redirect_to :action => :index }
    end
  end

  # GET /products/1/update_status
  def update_status
    @product = Product.find_by_pcode(params[:id])
    @product.toggle_status

    respond_to do |format|
      if @product.save
        format.js
        #format.html { redirect_to @product, notice: 'Product was successfully updated.' }
      else
        #format.html { render action: "edit" }
        format.js
      end
    end
  end

  # GET /products/1/upload
  def upload
    @product = Product.find_by_pcode(params[:id])

    respond_to do |format|
      format.js
    end
  end

  # PUT /products/1/upload_avatar
  def upload_avatar
    @product = Product.find_by_pcode(params[:id])
    @products = Product.list(@current_advertiser_id).paginate :page => params[:page], :per_page => ROWS_PRE_PAGE 
    @total_number = get_products_total_number @current_advertiser_id
    @spotted_number = get_products_spotted_number @current_advertiser_id

    respond_to do |format|
      if @product.update_attributes(params[:product])
        @success = 1;
        flash[:notice] = '成功上传产品图片'
      else
        flash[:notice] = '图片上传失败，请重试'
      end
      format.html { render 'upload_avatar' }
    end
  end

  # GET /products/1/statistics
  def statistics
    @product = Product.find_by_pcode(params[:id])
    @by = params[:by]
    group_by = @by == 'w' ? 'website_id' : 'log_date'
    get_product_statistics(@product.id, params[:start_date], params[:end_date], group_by)

    respond_to do |format|
      format.js #index.js.erb
    end
  end

private 

  def get_products_total_number(advertiser_id)
    Product.where(:advertiser_id => advertiser_id).count
  end

  def get_products_spotted_number(advertiser_id)
    0
  end

  def get_product_statistics(product_id, start_date, end_date, group_by)
    @statistics = SpotStatistics.search(:product_id => product_id, :start_date => start_date, :end_date => end_date, :group => group_by)
      .paginate :page => params[:page], :per_page => ROWS_PRE_PAGE 
    @total_impressions = 0
    @total_clicks = 0
    @total_incomes = 0

    @statistics.each do |t|
      @total_impressions += t.impression
      @total_clicks += t.click
      @total_incomes += t.income
    end
  end

  def check_privilege
    if session[:curadv].present? && session[:ucode].present?
      @current_advertiser_id = session[:curadv]
    else
      respond_to do |format|
        format.html { redirect_to signin_users_path(:backurl => request.url) }
      end
    end
  end

end
