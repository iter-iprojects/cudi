require 'test_helper'

class FilesuploadsControllerTest < ActionController::TestCase
  setup do
    @filesupload = filesuploads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:filesuploads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create filesupload" do
    assert_difference('Filesupload.count') do
      post :create, :filesupload => @filesupload.attributes
    end

    assert_redirected_to filesupload_path(assigns(:filesupload))
  end

  test "should show filesupload" do
    get :show, :id => @filesupload.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @filesupload.to_param
    assert_response :success
  end

  test "should update filesupload" do
    put :update, :id => @filesupload.to_param, :filesupload => @filesupload.attributes
    assert_redirected_to filesupload_path(assigns(:filesupload))
  end

  test "should destroy filesupload" do
    assert_difference('Filesupload.count', -1) do
      delete :destroy, :id => @filesupload.to_param
    end

    assert_redirected_to filesuploads_path
  end
end
