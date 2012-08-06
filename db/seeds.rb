# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.destroy_all
user = User.create(:user_code => 'UCODE001', :email => 'ramon_tong@126.com', :password => '123456', :login_ip => '127.0.0.1', :user_type => 1)

Advertiser.destroy_all
advertiser = Advertiser.create(:code => 'TESTCODE', :name => 'Test Adv', :homepage => 'http://www.adspot.cn')

advertiser.users << user
advertiser.save

Product.destroy_all
p = Product.new
p.pname = 'iphone 4s'
p.pcode = 'abc'
p.brand = 'apple'
p.description = 'Change the world again'
p.pricing = 1
p.pdct_price = 4999
p.unit_price = 3.5
p.upper_limit = 5000
p.pdct_thumb = nil
p.click_target = 'http://www.adspot.cn'
p.delivery_type = 1
p.delivery_rule = nil
p.status = 1
p.save

Tag.destroy_all
tag = Tag.create(:tname => 'Apple')

p.tags << tag
p.save
