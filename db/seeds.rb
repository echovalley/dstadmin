# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#User.destroy_all

def create_user(email, type)
  user = User.find_by_email(email)
  if user.blank?
    user = User.new
    user.user_code = 'US' + Utils.create_random_code(8)
    user.email = email
    user.update_password('adspot2012')
    user.login_ip = '127.0.0.1'
    user.user_type = type
    user.save
  end
  return user
end

def create_advertiser(user)
  adv = Advertiser.find_by_code('ADV001')
  adv = Advertiser.create(:code => 'ADV001', :name => 'Test Adv', :homepage => 'http://www.adspot.cn') if adv.blank?
  unless (adv.users.include?(user))
    adv.users << user
    adv.save
  end
end

def create_website_category
  wc = WebsiteCategory.first
  wc = WebsiteCategory.create(:wcname => '测试门户') if wc.blank?
end

def create_website(name, url, user)
  website = Website.find_by_url(url)
  if website.blank?
    website = Website.new
    website.update_website_code
    website.wname = name
    website.url = url
    website.pv = 1
    website.website_category_id = WebsiteCategory.first.id
    website.status = 1
    website.save
  end
  unless (website.users.include?(user))
    website.users << user
    website.save
  end
end

user1 = create_user('adspot_advertiser@126.com', User::TYPE_ADVERTISER)
user2 = create_user('adspot_website@126.com', User::TYPE_WEBSITE)
adv = create_advertiser(user1)

wc = create_website_category
website1 = create_website('Adspot', 'adspot.cn', user2)
website2 = create_website('Adspot Test', 'www.adspot-test.cn', user2)

