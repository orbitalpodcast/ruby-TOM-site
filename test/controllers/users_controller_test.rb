require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:subscribed_user_1)
  end

  test "should get index" do
    sign_in admins(:ben)
    get users_url
    assert_response :success
    sign_out :ben
  end

  test "should get new" do
    skip
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    skip
    assert_difference('User.count') do
      post users_url, params: { user: { admin: @user.admin, email: @user.email, password_digest: @user.password_digest, username: @user.username } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    sign_in admins(:ben)
    get user_url( @user )
    assert_response :success
    sign_out :ben
  end

  test "should get edit" do
    sign_in admins(:ben)
    get edit_user_url( @user )
    assert_response :success
    sign_out :ben
  end

  test "should update user" do
    sign_in admins(:ben)
    patch user_url(@user), params: { user: { email: 'fake_email@should-update-user.com' } }
    assert_redirected_to user_url(@user)
    sign_out :ben
  end

  test "should destroy user" do
    sign_in admins(:ben)
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end
    assert_redirected_to users_url
    sign_out :ben
  end
end
