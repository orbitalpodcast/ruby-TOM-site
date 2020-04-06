require 'test_helper'

class OrderControllerTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = true

  setup do
    @new_order = Order.new(products: Product.for_sale)
  end

  test "should get store" do
    get store_path
    assert_response :success
  end

  test "should create order" do # save new order, assign products, address and user
    assert_emails 1 do
      assert_difference('User.count', 1) do
        assert_difference('Order.count', 1) do
          post '/orders', params: { product_ids: @new_order.product_ids,
                                    email: 'not_in_fixtures@test.com',
                                    shipping_destination: 'US' }
        end
      end
    end
    assert_response :found
    assert_redirected_to edit_order_path assigns(:order)
    follow_redirect!
    assert_response :success
    assert assigns(:order).fresh?
  end

  test "should edit order" do # asks user for delivery address, change product quantities
    assert_no_difference('Order.count') do
      get edit_order_path orders(:created).id
    end
  end

  test "should update order" do # update address, call PayPal API, redirect to PayPal
    @order = orders(:ready_to_pay)
    
    # asking to update without executing paypal
    patch order_path(@order), params: { order: @order.attributes }
    assert_redirected_to edit_order_path
    follow_redirect!
    assert_response :success

    # asking to execute paypal
    patch order_path(@order), params: { order: @order.attributes,
                                        commit: "Continue to Paypal" }
    assert_redirected_to %r(^https:\/\/www\.sandbox\.paypal\.com\/checkoutnow\?token=[A-Z0-9]{17}$)
    assert assigns(:order).payment_pending?
    assert_not assigns(:order).token.blank?
  end

  # test "should finish order" do
    # TODO: allow client to return fake content in the test environment    
  # end

  test "should show order" do
    get order_path orders(:ready_to_pay)
    assert_response :success
  end

  test "should not create order without products" do
    assert_difference('Order.count', 0) do
      post '/orders', params: { email: 'not_in_fixtures@test.com',
                                shipping_destination: 'US' }
    end
    assert_response :found
    assert_redirected_to store_path
    follow_redirect!
    assert_response :success
    assert_equal "You can't check out with an empty cart.", flash[:alert]
  end

  test "should not create order without user signed in or created" do
    assert_difference('Order.count', 0) do
      post '/orders', params: { product_ids: @new_order.product_ids,
                                email: "",
                                shipping_destination: 'US' }
    end
    assert_response :found
    assert_redirected_to store_path
    follow_redirect!
    assert_response :success
    assert_equal "Please provide an email or log in.", flash[:alert]
  end

end
