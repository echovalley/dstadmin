require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  test "test_presence" do
    p = Product.new
    
    assert p.invalid?
    #p.errors[:pname]

    p.pname = 'product 001'
    p.pcode = p.create_product_code
    p.brand = 'my brand'
    p.delivery_rule = 1
    p.click_target = 'http://www.adspot.cn'
    p.pdct_price = '100'
    p.unit_price = 4
    p.pricing = 1
    p.status = 1
    p.advertiser = Advertiser.first
    
    assert p.valid?
  end
end
