class AdvertisersController < ApplicationController 

  # GET /advertisers/1
  # GET /advertisers/1.json
  def show
    @advertiser = Advertiser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /advertisers/1/edit
  def edit
    @advertiser = Advertiser.find(params[:id])
  end

  # PUT /advertisers/1
  # PUT /advertisers/1.json
  def update
    @advertiser = Advertiser.find(params[:id])

    respond_to do |format|
      if @advertiser.update_attributes(params[:advertiser])
        flash[:success] = 'Create successfully'
        format.html { redirect_to @advertiser }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # GET /advertiser/dashboard
  def dashboard
    period = params[:period].blank? ? 7 : params[:period].to_i
    start_date = params[:start_date]
    end_date = params[:end_date]

    if start_date.blank? || end_date.blank?
      end_date = Date.today
      start_date = end_date - period
    end

    @total_number = Product.count_products_by_advertiser get_current_advertiser_id
    @spotted_number = Product.count_products_spotted_by_advertiser get_current_advertiser_id
    @user = get_current_user
    @login_count = User.find_by_user_code(@user).login_count
    #advertiser = Advertiser.find(get_current_advertiser_id)
   
    get_dashboard_statistics_by_date(start_date, end_date, period) 
    get_dashboard_statistics_by_website(start_date, end_date, period)

    respond_to do |format|
      format.html 
    end
  end

private

  def get_dashboard_statistics_by_date(start_date = nil, end_date = nil, period = 7)
    array = SpotStatistics.search_by_advertiser(get_current_advertiser_id, :start_date => start_date, :end_date => end_date, :group => 'log_date') 
    flots = FlotFormat.transform(array, period - 1)
    @flot_impression_data = flots[:impression_data]
    @flot_click_data = flots[:click_data]
  end

  def get_dashboard_statistics_by_website(start_date = nil, end_date = nil, period = 7)
    @statistics_website = SpotStatistics.search_by_advertiser(
      get_current_advertiser_id, :start_date => start_date, :end_date => end_date, :group => 'website_id', :order => 'impression desc') 
  end
  
end
