# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#User.destroy_all
user = User.find_by_email('webmaster@adspot.cn')
if user.blank?
  user_code = 'US' + Utils.create_random_code(8)
  user = User.new
  user.user_code = user_code
  user.email = 'webmaster@adspot.cn'
  user.update_password('123456')
  user.login_ip = '127.0.0.1'
  user.user_type = User::TYPE_ADVERTISER
  user.save
end

adv = Advertiser.find_by_code('ADV001')
if adv.blank?
  advertiser = Advertiser.create(:code => 'ADV001', :name => 'Test Adv', :homepage => 'http://www.adspot.cn')
  advertiser.users << user
  advertiser.save
end

wc = WebsiteCategory.first
if wc.blank?
  wc = WebsiteCategory.create(:wcname => '测试门户')
end

website = Website.find_by_wname('Adspot.cn')
if website.blank?
  website = Website.new
  website.update_website_code
  website.wname = 'Adspot.cn'
  website.url = 'http://www.adspot.cn'
  website.pv = 1
  website.website_category_id = WebsiteCategory.first.id
  website.status = 1
end

