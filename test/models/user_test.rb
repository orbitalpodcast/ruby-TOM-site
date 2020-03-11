require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # BASIC VALIDS
  test 'Should validate valid new newsletter subscriber' do
    user = User.new email: 'valid@test.com', subscribed: true
    assert user.save
  end

  test 'Should default to not subscribed, not able to log in' do
    user = User.new email: 'defaults@test.com'
    assert user.save
    assert user.subscribed == false
    assert user.no_login?
  end

  # test 'Should validate TWSF user without email, and default to empty' do
  #   user = User.new
  #   assert user.save
  #   assert user.email.blank?
  # end

  # # BASIC INVALIDS
  test 'Should not validate user without unique email' do
    user = User.new email: users(:subscribed_user_0).email
    assert_not user.save
  end


  # # EMAIL REGEX
  test 'Should not validate user with wildly invalid email format' do
    user = User.new email: 'this is not an email'
    assert_not user.save
  end

  test 'Should validate user with + in email' do
    user = User.new email: 'test+spam@test.com'
    assert user.save
  end

  test 'Should validate user with other specials in email' do
    user = User.new email: 'test%@test.com'
    assert user.save
  end

  test 'Should validate user with european email TLD' do
    user = User.new email: 'test@test.co.uk'
    assert user.save
  end

  test 'Should validate user with hyphen in email domain' do
    user = User.new email: 'test@test-server.com'
    assert user.save
  end

  test 'Should not validate user with invalid specials in email' do
    user = User.new email: 'test#@test.com'
    assert_not user.save
  end

  test 'Should not validate user with an email missing @' do
    user = User.new email: 'testtest.com'
    assert_not user.save
  end

  test 'Should not validate user with an email with invalid TLD' do
    user = User.new email: 'test@test.c'
    assert_not user.save
  end

  # PASSWORD REGEX
  # Currently using Devise' default length validation and nothing else. We're not storing payment info,
  # so this isn't completely horrible, but I'd like to update it at some point.
  # TODO implement devise_security_extension gem.

  # test 'Should not validate user with short password' do
  #   user = User.new(email: 'test@test.com', admin: true, password: 'V&r0')
  #   assert_not user.save
  # end

  # test 'Should not validate user with password missing digit' do
  #   user = User.new(email: 'test@test.com', admin: true, password: 'VSkI3n&r0Q9k2XFZGxUi'.gsub(/\d/,''))
  #   assert_not user.save
  # end

  # test 'Should not validate user with password missing lower character' do
  #   user = User.new(email: 'test@test.com', admin: true, password: 'VSkI3n&r0Q9k2XFZGxUi'.upcase)
  #   assert_not user.save
  # end

  # test 'Should not validate user with password missing upper character' do
  #   user = User.new(email: 'test@test.com', admin: true, password: 'VSkI3n&r0Q9k2XFZGxUi'.downcase)
  #   assert_not user.save
  # end

  # test 'Should not validate user with password missing special character' do
  #   user = User.new(email: 'test@test.com', admin: true, password: 'VSkI3n&r0Q9k2XFZGxUi'.gsub(/[\W_]/,''))
  #   assert_not user.save
  # end

end