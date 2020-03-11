require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  # include Devise::Test:IntegrationHelpers

  test "user signup as newsletter subscriber" do
    get newsletter_path
    assert_response :success
    assert_template 'newsletter/new'
    assert_select "input[id=user_email]"
    assert_select "input[name=commit]" do
      assert_select '[value=?]', 'Sign up'
    end
    assert_select 'form[class=button_to]', 0

    assert_emails 1 do
      post newsletter_path, params: {user: {email:'new_test_user@test.com', subscribed: 'true'}}
    end
    assert_response :success
    assert_template 'newsletter/new'
    assert_equal 'Please check your email for a confirmation link.', flash[:notice]
    refute assigns(:user).confirmed?

    get user_confirmation_path, params: {confirmation_token: assigns(:user).confirmation_token}
    assert_redirected_to new_user_session_url
    assert_equal 'Your email address has been successfully confirmed.', flash[:notice]

  end

  test "resend confirmation email" do
    assert_emails 0 do
      post newsletter_path, params: {user: {email: users(:not_subscribed_user_1).email, subscribed: 'true'}}
    end
    follow_redirect!
    assert_equal "Email has already been taken", flash[:alert]
    assert_select "form[class=button_to]" do
      assert_select 'input[value=?]', 'Resend confirmation instructions'
    end

  end

  # test "user signup as new customer" do
  #   skip
  # end

  # test "newsletter subscriber add customer data" do
  #   skip
  # end

  # test "customer add new newsletter subscription" do
  #   skip
  # end

  test "user signup with no customer data or newsletter subscription" do
    assert_no_changes User.count do
      post newsletter_path, params: {user: {email:'new_test_user@test.com', subscribed: '0'}}
    end
    assert_equal "Getting mixed messages. Did you uncheck the subscribe button?", flash[:alert]
  end

  test "newsletter unsubscribe" do
    @user = User.find_by(email: users(:subscribed_user_1).email)
    assert @user.subscribed?
    get unsubscribe_newsletter_path(users(:subscribed_user_1).quick_unsubscribe_token)
    assert_redirected_to root_url
    assert_equal "Unsubscribed and deleted account.", flash[:notice]
    assert_raises(ActiveRecord::RecordNotFound) do
      @user.reload
    end
  end

  test "newsletter unsubscribe without token" do
    assert_emails 0 do
      get user_confirmation_path, params: {confirmation_token: ''}
    end
    assert_response :success
    assert_select "div[id=error_explanation]" do
      assert_select 'li', "Confirmation token can't be blank"
    end
  end

end
