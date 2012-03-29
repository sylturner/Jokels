require 'test_helper'

class FavoriteJokesControllerTest < ActionController::TestCase
  setup do
    @favorite_joke = favorite_jokes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favorite_jokes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favorite_joke" do
    assert_difference('FavoriteJoke.count') do
      post :create, :favorite_joke => @favorite_joke.attributes
    end

    assert_redirected_to favorite_joke_path(assigns(:favorite_joke))
  end

  test "should show favorite_joke" do
    get :show, :id => @favorite_joke.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @favorite_joke.to_param
    assert_response :success
  end

  test "should update favorite_joke" do
    put :update, :id => @favorite_joke.to_param, :favorite_joke => @favorite_joke.attributes
    assert_redirected_to favorite_joke_path(assigns(:favorite_joke))
  end

  test "should destroy favorite_joke" do
    assert_difference('FavoriteJoke.count', -1) do
      delete :destroy, :id => @favorite_joke.to_param
    end

    assert_redirected_to favorite_jokes_path
  end
end
