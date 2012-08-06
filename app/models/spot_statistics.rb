class SpotStatistics < ActiveRecord::Base
  attr_accessible :click, :impression, :income, :log_date
  belongs_to :spot
  belongs_to :website
  belongs_to :product

  def self.search(options = {})
    group_by = options[:group]
    start_date = options[:start_date]
    end_date = options[:end_date]

    start_date = '2012-01-01'.to_date if start_date.blank?
    end_date = Time.now.to_date if end_date.blank?

    aggregation_columns = "sum(impression) as impression, sum(click) as click, sum(income) as income "
    entity_name = nil
    entity_id = nil
    options.each_key do |k| 
      unless k =~ /start_date|end_date|group/
        entity_name = k.to_s
        entity_id = options[k]
        break
      end
    end

    aggregation_columns += ", " + entity_name
    aggregation_columns += ", " + group_by if group_by.present? && group_by != entity_name 

    if group_by.present?
      SpotStatistics.where(entity_name => entity_id, :log_date => (start_date)..(end_date)).select(aggregation_columns).group(group_by).all
    else
      SpotStatistics.where(entity_name => entity_id, :log_date => (start_date)..(end_date)).select(aggregation_columns).all
    end

  end
end
