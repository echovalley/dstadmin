class FlotFormat

  # Transfer the query result from database(Array) to the format flot need
  def self.transform(array, ticks)
    impr_array = []
    ck_array = []
    hash = {}

    array.each do |t|
      hash[t.log_date] = [t.impression, t.click]
    end

    max_date = Date.today
    min_date = Date.today - ticks

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
