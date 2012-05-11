require 'test_helper'

class ProyectoresourcesControllerTest < ActionController::TestCase
  setup do
    @proyectoresource = proyectoresources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proyectoresources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proyectoresource" do
    assert_difference('Proyectoresource.count') do
      post :create, :proyectoresource => @proyectoresource.attributes
    end

    assert_redirected_to proyectoresource_path(assigns(:proyectoresource))
  end

  test "should show proyectoresource" do
    get :show, :id => @proyectoresource.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @proyectoresource.to_param
    assert_response :success
  end

  test "should update proyectoresource" do
    put :update, :id => @proyectoresource.to_param, :proyectoresource => @proyectoresource.attributes
    assert_redirected_to proyectoresource_path(assigns(:proyectoresource))
  end

  test "should destroy proyectoresource" do
    assert_difference('Proyectoresource.count', -1) do
      delete :destroy, :id => @proyectoresource.to_param
    end

    assert_redirected_to proyectoresources_path
  end
end
