require 'test_helper'

class ProyectostatusesControllerTest < ActionController::TestCase
  setup do
    @proyectostatus = proyectostatuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proyectostatuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proyectostatus" do
    assert_difference('Proyectostatus.count') do
      post :create, :proyectostatus => @proyectostatus.attributes
    end

    assert_redirected_to proyectostatus_path(assigns(:proyectostatus))
  end

  test "should show proyectostatus" do
    get :show, :id => @proyectostatus.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @proyectostatus.to_param
    assert_response :success
  end

  test "should update proyectostatus" do
    put :update, :id => @proyectostatus.to_param, :proyectostatus => @proyectostatus.attributes
    assert_redirected_to proyectostatus_path(assigns(:proyectostatus))
  end

  test "should destroy proyectostatus" do
    assert_difference('Proyectostatus.count', -1) do
      delete :destroy, :id => @proyectostatus.to_param
    end

    assert_redirected_to proyectostatuses_path
  end
end
