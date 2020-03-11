require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  
  # BASIC VALIDS
  test 'Should validate new valid admin' do
    skip
    admin = Admin.new
  end

  # INVALIDS
  test 'Should not validate admin without password' do
    admin = Admin.new email: 'no_password@test.com'
    assert_not admin.save
  end

end
