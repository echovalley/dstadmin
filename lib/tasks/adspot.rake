namespace :adspot do
  desc 'Ad spot statistics report calculation'
  task :statistics, [:log_hour] => :environment do |t, args|
    args.with_defaults(:log_hour => Time.now.strftime("%Y%m%d%H"))
    hourly_statistics(args.log_hour)
  end

  namespace :fetch do
    desc 'Collect urls for fetching untagged images'
    task :urls do
    end

  end

  def hourly_statistics(log_hour)
    hash_images = {}
    hash_spots = {}

    log_file = locate_log_file(log_hour)
    gz = Zlib::GzipReader.open(log_file)

    gz.each_line do |line|
      params = parse_parameters(line)
      break if params.blank?

      t = params['t']
      imgid = params['imgid']
      sid = params['sid']
      pid = params['pid']

      if (t == 'im' || t == 'ih') && is_valid_id(imgid)
        k = imgid.to_s
        hash_images[k] = {} if hash_images[k].blank?
        hash_images[k][t].present? ? hash_images[k][t] += 1 : hash_images[k][t] = 1
      elsif (t == 'sh' || t == 'sc') && is_valid_id(sid)
        k = is_valid_id(pid) ? sid.to_s + '_' + pid.to_s : sid.to_s
        hash_spots[k] = {} if hash_spots[k].blank?
        hash_spots[k][t].present? ? hash_spots[k][t] += 1 : hash_spots[k][t] = 1
      end
    end

    #puts hash_images
    #puts hash_spots
    hash_images.keys.each do |t|
      impressions = hash_images[t]['im']
      impressions = 0 if impressions.blank?
      hovers = hash_images[t]['ih']
      hovers = 0 if hovers.blank?
      clicks = 0 #Not track now
      TaggedImageStatistics.create(:tagged_image_id => t, :log_date => log_hour.to_date, :impression => impressions, :click => clicks, :hover => hovers)
    end

    hash_spots.keys.each do |t|
      arr = t.split('_')
      spot_id = arr[0]
      product_id = arr.length == 2 ? arr[1] : 0

      impressions = hash_spots[t]['sh']
      impressions = 0 if impressions.blank?
      clicks = hash_spots[t]['sc']
      clicks = 0 if clicks.blank?
      income = product_id != 0 ? income_CPC(product_id, clicks) : 0

      website_id = TaggedImage.get_website_id_by_spot(spot_id)
      SpotStatistics.create(:spot_id => spot_id, :log_date => log_hour.to_date, :impression => impressions, :click => clicks, :income => income, :website_id => website_id, :product_id => product_id)
    end

    if log_hour[8,2] == '23'
      log_date = log_hour[0,8]
      daily_summarize(log_date)
    end
  end


  def locate_log_file(strTime)
    BASIC_LOG_DIR + '/' + strTime[0,6] + '/' + strTime[6,2] + '/' + strTime[8,2] + '.log.gz'
  end

  def parse_parameters(line)
    params = {}
    if line =~ /\/ads\/pixel\.php\?(\S+)$/
      str = $1
      str.split('&').each do |t|
        _arr = t.split('=')
        params[_arr[0]] = _arr[1] if _arr[1].present?
      end
    end
    return params
  end

  def income_CPC(product_id, clicks)
    product = Product.find_by_id(product_id)
    return 0 unless product.pricing == Product::PRICING_CPC
    product.unit_price.to_f * clicks.to_f;
  end

  def daily_summarize(log_date)
    date_str = log_date.to_date.to_s(:db)

    max_id = TaggedImageStatistics.maximum("id")
    sql = "insert into tagged_image_statistics(tagged_image_id,log_date,impression,click,hover) select tagged_image_id,log_date,sum(impression),sum(click),sum(hover) from tagged_image_statistics where log_date='" + date_str + "' group by tagged_image_id"
    ActiveRecord::Base.connection.execute(sql)
    TaggedImageStatistics.where(:log_date =>log_date.to_date).where("id<=?", max_id).delete_all

    max_id = SpotStatistics.maximum("id")
    sql = "insert into spot_statistics(spot_id,log_date,impression,click,income,website_id,product_id) select spot_id,log_date,sum(impression),sum(click),sum(income),website_id,product_id from spot_statistics where log_date='" + date_str + "' group by spot_id,website_id,product_id"
    ActiveRecord::Base.connection.execute(sql)
    SpotStatistics.where(:log_date =>log_date.to_date).where("id<=?", max_id).delete_all
  end

  def is_valid_id(id)
    id.present? && id.to_i.is_a?(Numeric)
  end

end
