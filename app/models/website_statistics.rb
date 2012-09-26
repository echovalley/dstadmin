class WebsiteStatistics < ActiveRecord::Base
  attr_accessible :click, :impression, :income, :log_date
  belongs_to :website

  def self.search_by_website(website_id)
    statistics = SpotStatistics.search(:start_date => '2012-8-1', :website_id => website_id)
  end
end
