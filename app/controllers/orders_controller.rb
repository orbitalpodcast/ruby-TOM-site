class OrdersController < ApplicationController
  # Store orders are executed as RESTfully as possible. Right now, only Paypal is supported.
  # NEW lists all products, and POSTs product selections to create.
  # CREATE saves a new @order with the selected products, assigns a user, GETs edit
  # EDIT collects a delivery address and PATCHes to update.
  # UPDATE saves the address, calls Paypal API, and redirects the user to Paypal's authorize URL
  # Paypal redirects the user to FINISH, which captures the payment and serves a confirmation page/email.

  # GET /store
  def new
    @order = Order.new()
    @order.products << Product.for_sale
  end

  # POST /store/create
  def create
    # CATCH EARLY ERRORS
    if params[:product_ids].nil?
      redirect_to(store_url, alert: "You can't check out with an empty cart.") and return
    elsif params[:email].empty?
      redirect_to(store_url, alert: "Please provide an email.") and return
    end

    # BUILD ORDER
    products = Product.find(params[:product_ids])
    @order = Order.new(products: products, payment_gateway: :paypal)
    @order.address ||= Address.new
    if params[:shipping_destination] == "US"
      # after_save callback will update totals, and shipping is based on country
      @order.address.country = "US"
    end

    # ASSIGN USER
    if user_signed_in?
      @order.user = current_user
    else
      # TODO: change user confirmation email to account for not subscribed users
      # TODO: move user account creation to orders#edit so that the confirmation email isn't geneated
      # so early in the flow.
      # TODO: Account for email format validation in orders#create
      user = User.find_or_create_by(email: params[:email])
      if user.active_for_authentication?
        redirect_to(new_user_session_path, 
                       notice: "You already have an account. Please log in and try again.") and return
        # TODO: is orders#create a little hostile? Should orders be allowed to not have a user account?
        # Alternatively, should guest orders just not get displayed in user order lists?
      else
        @order.user = user 
        # TODO: if a guest user is assigned, add an authentication token to the order
      end
    end

    # ASK FOR SHIPPING DETAILS
    if @order.save
      redirect_to edit_order_path @order
    else
      render :new, alert: "Something went wrong creating your order."
    end
  end

  # GET /store/1/edit
  def edit
    @order = Order.find(params[:id])
    # @stored_addresses = user.addresses + order.addresses
  end

  # PATCH/PUT /store/1
  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      # TODO: in order#update, don't update quantities if continue to paypal was clicked or add confirmation page
      if params[:commit] == 'Continue to Paypal'
        # TODO: add admin confirmation of orders over a certain dollar amount
        ex_response, ex_links = create_and_execute_paypal_order
        if @order.update(charge_id: ex_response.result.id,
                         links: ex_links,
                         token: ex_response.result.id)
          redirect_to @order.links[:approve]
        else
          redirect_to edit_order_path @order
        end
      elsif params[:commit] == 'Update quantities'
        redirect_to edit_order_path @order
      end
    else # let the user know why the order didn't update
      redirect_to edit_order_path @order
    end
  end

  # GET /store/:payment_gateway/:payment_status
  # Includes :token and :PayerID
  def finish
    @order = Order.find_by( payment_gateway: params[:payment_gateway], token: params[:token] )
    @order.paid!
    redirect_to order_path @order, notice: "Your order was successfully placed! Please reply to the order confirmation email if you have any questions or instructions."
  end

  # GET /store/1
  def show
    @order = Order.find params[:id]
  end

  private

  def create_and_execute_paypal_order
    @order.payment_pending!
    # BUILD PAYPAL CREATE_ORDER REQUEST
    request = PayPalCheckoutSdk::Orders::OrdersCreateRequest::new
    items = []
    for product in @order.products do
      items << {name: product.name,
                unit_amount: {currency_code: 'USD',
                              value: product.price_cents/100.0},
                quantity: product.quantity,
                category: 'PHYSICAL_GOODS'}
    end
    body = {intent: 'CAPTURE',
            application_context: {return_url: 'http://localhost:3000/order_return/paypal/return',
                                  cancel_url: 'http://localhost:3000/order_return/paypal/cancel',
                                  user_action: 'PAY_NOW',
                                  shipping_preference: 'NO_SHIPPING'},
            purchase_units: [{
              reference_id: "TOM_STORE_ORDER_##{@order.id}",
              amount: {
                currency_code: 'USD',
                value: @order.total_cents/100.0,
                breakdown: {
                  item_total: {currency_code: 'USD', value: @order.subtotal_cents/100.0},
                  shipping: {currency_code: 'USD', value: @order.ship_cents/100.0}
                }},
              items: items
            }]
           }
    request.prefer('return=representation')
    request.request_body(body)
    # EXECUTE PAYPAL CREATE_ORDER REQUEST
    debug :'body', binding
    begin
      ex_response = PayPalClient::client.execute(request)
      debug :"ex_response", binding
      # PROCESS PAYPAL RESPONSE
    rescue PayPalHttp::HttpError => ioe
      # something went wrong server-side
      @order.payment_failed!
      # TODO: handle paypal HTTP errors
      debug :"Something went wrong with Paypal authorization"
      debug :'ioe.status_code', binding
      debug :"ioe.headers['debug_id']", binding
      debug :"ioe.result", binding
      # ioe.result.name == "INVALID_REQUEST"
      # ioe.result.details.each field, value, issue, description
      # TODO: orders#update should retry paypal with get_from_file if malformed address?
    end
    ex_links = ex_response.result.links.inject({}) { |memo, link| memo[link.rel.to_sym] = link.href; memo }
    return ex_response, ex_links
  end

  def order_params
    params.require(:order).permit(:token, :charge_id,
      address_attributes: [:id, :full_name, :street1, :street2, :city, :state, :postcode, :country],
      orders_products_attributes: [:id, :quantity, :product_id])
  end

end