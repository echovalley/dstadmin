class FlotFormat

  # Transfer the query result from database(Array) to the format flot need
  def self.transform(array, ticks)
    impr_array = []
    ck_array = []
    hash = {}
    
    min_date = max_date = nil

    array.each do |t| 
      max_date = t.log_date if max_date.blank? || max_date < t.log_date 
      min_date = t.log_date if min_date.blank? || min_date > t.log_date 
      hash[t.log_date] = [t.impression, t.click]
    end

    if min_date.blank?
      max_date = Date.today
      min_date = Date.today - 7
    else
      min_date = max_date - ticks if max_date - min_date < ticks
    end

    (min_date .. max_date).each do |t|
      impr = ck = 0
      if hash[t].present?
         impr = hash[t][0] if hash[t][0].present?
         ck = hash[t][1] if hash[t][1].present?
      end
      impr_array.push [t.to_time.to_i*1000, impr]
      ck_array.push [t.to_time.to_i*1000, ck]
    end

    { :impression_data => impr_array, :click_data => ck_array }
  end

end
