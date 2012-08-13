class SpotStatistics < ActiveRecord::Base
  attr_accessible :click, :impression, :income, :log_date
  belongs_to :spot
  belongs_to :website
  belongs_to :product

  def self.search(options = {})
    group_by = options[:group]
    group_by = [group_by] if group_by.is_a? String 

    order_by = options[:order]
    order_by = [order_by] if order_by.is_a? String 

    start_date = options[:start_date].blank? ? default_start_date : options[:start_date]
    end_date = options[:end_date].blank? ? default_end_date : options[:end_date]
    advertiser_id = options[:advertiser_id]

    columns = ['sum(impression) as impression', 'sum(click) as click', 'sum(income) as income']
    group_by.each { |t| columns << t } if group_by.present?

    conditions = {:log_date => (start_date) .. (end_date)}
    ['product_id', 'website_id', 'spot_id'].each { |t| conditions[t.to_sym] = options[t.to_sym] if options[t.to_sym].present? }

    conditions[:products] = {:advertiser_id => advertiser_id} if advertiser_id.present?

    relation = SpotStatistics.select(columns)
    relation = relation.joins(:product) if advertiser_id.present?
    relation.where(conditions).group(group_by).order(order_by)
  end

  def self.search_by_advertiser(advertiser_id, options = {})
    options[:advertiser_id] = advertiser_id
    search(options)
  end

private

  def self.default_start_date
    Date.today - 7
  end

  def self.default_end_date
    Date.today
  end
end
