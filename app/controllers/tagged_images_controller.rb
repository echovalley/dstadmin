# encoding: utf-8
class TaggedImagesController < ApplicationController
  
  ROWS_PRE_PAGE = 5

  before_filter :check_website_permission

  # GET /tagged_images
  def index
    website_info
    @tagged_images = TaggedImage.find_by_website(@website.id, 'created_at').paginate(:page => params[:page], :per_page => ROWS_PRE_PAGE)
    @tagged_images.each { |t| t.count_spots }
    respond_to do |format|
      format.html
    end
  end

  # POST /tagged_images/search
  def search
    @website = Website.find_by_wcode(params[:website_id])
    params[:website_id] = @website.id #use true id instead of wcode
    @tagged_images = TaggedImage.search(params).paginate(:page => params[:page], :per_page => ROWS_PRE_PAGE)
    @tagged_images.each { |t| t.count_spots }
    @keyword = params[:keyword]
    @order_by = params[:order_by]

    respond_to do |format|
      format.js { render 'search' }
    end
  end

  # GET /tagged_images/1
  def show
    @website = Website.find_by_wcode(params[:website_id])
    @tagged_image = TaggedImage.includes(:spots).where(:id => params[:id]).first
    @products = @tagged_image.get_linked_products

    @statistics = get_tagged_image_statistics(@tagged_image.id, Date.today-7, Date.today)

    respond_to do |format|
      format.js # show.js.erb
    end
  end

  # GET /tagged_images/1/statistics_tagged_image
  def statistics_tagged_image
    @statistics = get_tagged_image_statistics(params[:id], params[:start_date], params[:end_date])
    respond_to do |format|
      format.js
    end
  end


  # GET /tagged_images/1/statistics_spots
  def statistics_spots
    @statistics = get_spots_statistics(params[:id], params[:start_date], params[:end_date])
    respond_to do |format|
      format.js
    end
  end

private

  def check_website_permission
    website = Website.find_by_wcode(params[:website_id])
    unless website.present? && website.check_permission(get_current_user)
      respond_to do |format|
        format.html { redirect_to error_path } 
      end
    end
  end

  def my_verified_websites
    Website.search_by_user(get_current_user, Website::STATUS_VERIFIED)
  end

  def website_info
    @website = Website.find_by_wcode(params[:website_id])
    @website.count_tagged_images
    @website.count_untagged_images
    @websites = my_verified_websites
    @total_images_statistics = @website.get_total_tagged_images_statistics
    @total_spots_statistics = @website.get_total_spots_statistics
  end

  def get_tagged_image_statistics(id, start_date, end_date)
    statistics = TaggedImageStatistics.search(:tagged_image_id => id, :start_date => start_date, :end_date => end_date, :group => 'log_date').paginate(:page => params[:page], :per_page => ROWS_PRE_PAGE)
    @statistics = TaggedImageStatistics.include_spots_statistics(statistics, id, start_date, end_date)
    @total = Hash[:impression => 0, :hover => 0, :spots_impression => 0, :spots_click => 0, :spots_income => 0]
    @statistics.each do |t|
      [:impression, :hover, :spots_impression, :spots_click, :spots_income].each { |s| @total[s] += t.send(s.to_s) }
    end
  end

  def get_spots_statistics(id, start_date, end_date)
    @statistics = SpotStatistics.search(:tagged_image_id => id, :start_date => start_date, :end_date => end_date, :group => 'spot_id').paginate(:page => params[:page], :per_page => ROWS_PRE_PAGE)
    @total = Hash[:impression => 0, :click => 0, :income => 0]
    @statistics.each do |t|
      [:impression, :click, :income].each { |s| @total[s] += t.send(s.to_s) }
    end
  end

end
