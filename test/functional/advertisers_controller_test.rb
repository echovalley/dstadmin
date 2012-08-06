require 'test_helper'

class AdvertisersControllerTest < ActionController::TestCase
  setup do
    @advertiser = advertisers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:advertisers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create advertiser" do
    assert_difference('Advertiser.count') do
      post :create, advertiser: { address: @advertiser.address, code: @advertiser.code, homepage: @advertiser.homepage, integer: @advertiser.integer, mobile: @advertiser.mobile, name: @advertiser.name, open: @advertiser.open, status: @advertiser.status, tel: @advertiser.tel, zip: @advertiser.zip }
    end

    assert_redirected_to advertiser_path(assigns(:advertiser))
  end

  test "should show advertiser" do
    get :show, id: @advertiser
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @advertiser
    assert_response :success
  end

  test "should update advertiser" do
    put :update, id: @advertiser, advertiser: { address: @advertiser.address, code: @advertiser.code, homepage: @advertiser.homepage, integer: @advertiser.integer, mobile: @advertiser.mobile, name: @advertiser.name, open: @advertiser.open, status: @advertiser.status, tel: @advertiser.tel, zip: @advertiser.zip }
    assert_redirected_to advertiser_path(assigns(:advertiser))
  end

  test "should destroy advertiser" do
    assert_difference('Advertiser.count', -1) do
      delete :destroy, id: @advertiser
    end

    assert_redirected_to advertisers_path
  end
end
