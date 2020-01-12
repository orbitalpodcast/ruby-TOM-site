require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # BASIC VALIDS
  test 'Should validate valid new non-admin subscriber' do
    user = User.new(email: 'test@test.com', subscribed: true)
    assert user.save
  end

  test 'Should validate valid new admin' do
    user = User.new(email: 'test@test.com', admin: true, password: 'VSkI3n&r0Q9k2XFZGxUi')
    assert user.save
  end

  # BASIC INVALIDS
  test 'Should not validate user without email' do
    user = User.new(subscribed: true)
    assert_not user.save
  end

  test 'Should not validate user without unique email' do
    user = User.new(email: users(:user_1).email, subscribed: true)
    assert_not user.save
  end

  test 'Should not validate admin without password' do
    user = User.new(email: 'test@test.com', admin: true)
    assert_not user.save
  end

  # EMAIL REGEX
  test 'Should not validate user with wildly invalid email format' do
    user = User.new(email: 'this is not an email', subscribed: true)
    assert_not user.save
  end

  test 'Should validate user with + in email' do
    user = User.new(email: 'test+spam@test.com', subscribed: true)
    assert user.save
  end

  test 'Should validate user with other specials in email' do
    user = User.new(email: 'test%@test.com', subscribed: true)
    assert user.save
  end

  test 'Should validate user with european email TLD' do
    user = User.new(email: 'test@test.co.uk', subscribed: true)
    assert user.save
  end

  test 'Should validate user with hyphen in email domain' do
    user = User.new(email: 'test@test-server.com', subscribed: false)
    assert user.save
  end

  test 'Should not validate user with invalid specials in email' do
    user = User.new(email: 'test#@test.com', subscribed: true)
    assert_not user.save
  end

  test 'Should not validate user with an email missing @' do
    user = User.new(email: 'testtest.com', subscribed: true)
    assert_not user.save
  end

  test 'Should not validate user with an email with invalid TLD' do
    user = User.new(email: 'test@test.c', subscribed: true)
    assert_not user.save
  end

  # PASSWORD REGEX

  test 'Should not validate user with short password' do
    user = User.new(email: 'test@test.com', admin: true, password: 'V&r0')
    assert_not user.save
  end

  test 'Should not validate user with password missing digit' do
    user = User.new(email: 'test@test.com', admin: true, password: 'VSkI3n&r0Q9k2XFZGxUi'.gsub(/\d/,''))
    assert_not user.save
  end

  test 'Should not validate user with password missing lower character' do
    user = User.new(email: 'test@test.com', admin: true, password: 'VSkI3n&r0Q9k2XFZGxUi'.upcase)
    assert_not user.save
  end

  test 'Should not validate user with password missing upper character' do
    user = User.new(email: 'test@test.com', admin: true, password: 'VSkI3n&r0Q9k2XFZGxUi'.downcase)
    assert_not user.save
  end

  test 'Should not validate user with password missing special character' do
    user = User.new(email: 'test@test.com', admin: true, password: 'VSkI3n&r0Q9k2XFZGxUi'.gsub(/[\W_]/,''))
    assert_not user.save
  end

end