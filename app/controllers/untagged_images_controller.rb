# encoding: utf-8
#class UntaggedImagesController < ApplicationController
class UntaggedImagesController < TaggedImagesController
  
  ROWS_PRE_PAGE = 5

  # GET /untagged_images
  def index
    website_info
    @untagged_images = UntaggedImage.find_by_website(@website.id, 'created_at').paginate(:page => params[:page], :per_page => ROWS_PRE_PAGE)
    respond_to do |format|
      format.html
    end
  end

  # POST /untagged_images/search
  def search
    @website = Website.find_by_wcode(params[:website_id])
    params[:website_id] = @website.id #use true id instead of wcode
    @untagged_images = UntaggedImage.search(params).paginate(:page => params[:page], :per_page => ROWS_PRE_PAGE)
    @keyword = params[:keyword]
    @order_by = params[:order_by]

    respond_to do |format|
      format.js { render 'search' }
    end
  end

  # GET /untagged_images/1
  def show
    @website = Website.find_by_wcode(params[:website_id])
    @untagged_image = UntaggedImage.where(:id => params[:id]).first

    respond_to do |format|
      format.js # show.js.erb
    end
  end

end
