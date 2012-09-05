class TaggedImageStatistics < ActiveRecord::Base
  attr_accessible :click, :impression, :hover, :log_date
  belongs_to :tagged_image
  attr_accessor :spots_impression, :spots_click, :spots_income

  #Example: TaggedImageStatistics.search(:tagged_image_id=> 1, :start_date => '2012-8-1'.to_date, :end_date => '2012-8-7'.to_date, :group => 'log_date', :order => 'log_date')
  def self.search(options = {})
    group_by = options[:group]
    group_by = [group_by] if group_by.is_a? String 

    order_by = options[:order]
    order_by = [order_by] if order_by.is_a? String 

    start_date = options[:start_date].blank? ? default_start_date : options[:start_date]
    end_date = options[:end_date].blank? ? default_end_date : options[:end_date]
    website_id = options[:website_id]

    columns = ['sum(impression) as impression', 'sum(click) as click, sum(hover) as hover']
    group_by.each { |t| columns << t } if group_by.present?

    conditions = {:log_date => (start_date) .. (end_date)}
    conditions[:tagged_image_id] = options[:tagged_image_id] if options[:tagged_image_id].present?
    conditions[:tagged_images] = {:website_id => website_id } if website_id.present?

    relation = TaggedImageStatistics.select(columns)
    relation = relation.joins(:tagged_image) if website_id.present?
    relation.where(conditions).group(group_by).order(order_by)
  end

  def self.search_by_website(website_id, options = {})
    options[:website_id] = website_id 
    search(options)
  end

  def self.include_spots_statistics(statistics, tagged_image_id, start_date, end_date)
    h = Hash.new
    SpotStatistics.search(:tagged_image_id => tagged_image_id, :start_date => start_date, :end_date => end_date, :group => 'log_date').each do |t|
      h[t.log_date] = [t.impression, t.click, t.income]
    end

    statistics.each do |s|
      s.spots_impression = h[s.log_date][0]
      s.spots_click = h[s.log_date][1]
      s.spots_income = h[s.log_date][2]
    end

    return statistics
  end

private

  def self.default_start_date
    '2012-1-1'.to_date
  end

  def self.default_end_date
    Date.today
  end
end
