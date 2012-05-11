require 'test_helper'

class ConfirmationusersControllerTest < ActionController::TestCase
  setup do
    @confirmationuser = confirmationusers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:confirmationusers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create confirmationuser" do
    assert_difference('Confirmationuser.count') do
      post :create, :confirmationuser => @confirmationuser.attributes
    end

    assert_redirected_to confirmationuser_path(assigns(:confirmationuser))
  end

  test "should show confirmationuser" do
    get :show, :id => @confirmationuser.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @confirmationuser.to_param
    assert_response :success
  end

  test "should update confirmationuser" do
    put :update, :id => @confirmationuser.to_param, :confirmationuser => @confirmationuser.attributes
    assert_redirected_to confirmationuser_path(assigns(:confirmationuser))
  end

  test "should destroy confirmationuser" do
    assert_difference('Confirmationuser.count', -1) do
      delete :destroy, :id => @confirmationuser.to_param
    end

    assert_redirected_to confirmationusers_path
  end
end
