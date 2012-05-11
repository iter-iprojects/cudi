require 'test_helper'

class ProyectosControllerTest < ActionController::TestCase
  setup do
    @proyecto = proyectos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proyectos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proyecto" do
    assert_difference('Proyecto.count') do
      post :create, :proyecto => @proyecto.attributes
    end

    assert_redirected_to proyecto_path(assigns(:proyecto))
  end

  test "should show proyecto" do
    get :show, :id => @proyecto.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @proyecto.to_param
    assert_response :success
  end

  test "should update proyecto" do
    put :update, :id => @proyecto.to_param, :proyecto => @proyecto.attributes
    assert_redirected_to proyecto_path(assigns(:proyecto))
  end

  test "should destroy proyecto" do
    assert_difference('Proyecto.count', -1) do
      delete :destroy, :id => @proyecto.to_param
    end

    assert_redirected_to proyectos_path
  end
end
