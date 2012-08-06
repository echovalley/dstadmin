require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: { brand: @product.brand, click_target: @product.click_target, delivery_rule: @product.delivery_rule, delivery_type: @product.delivery_type, description: @product.description, pcode: @product.pcode, pdct_price: @product.pdct_price, pdct_thumb: @product.pdct_thumb, pname: @product.pname, pricing: @product.pricing, status: @product.status, upper_limit: @product.upper_limit }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    put :update, id: @product, product: { brand: @product.brand, click_target: @product.click_target, delivery_rule: @product.delivery_rule, delivery_type: @product.delivery_type, description: @product.description, pcode: @product.pcode, pdct_price: @product.pdct_price, pdct_thumb: @product.pdct_thumb, pname: @product.pname, pricing: @product.pricing, status: @product.status, upper_limit: @product.upper_limit }
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end

    assert_redirected_to products_path
  end
end
