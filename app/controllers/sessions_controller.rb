class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :welcome]

  # GET login
  def new
  end

  # POST/PUT login
  def create
    logger.debug ">>>>>>> session#create was invoked"
    @pre_login_request = session[:pre_login_request]
    reset_session
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      logger.debug ">>>>>>> user successfully logged in"
      session[:user_id] = @user.id
      if @pre_login_request
        redirect_to @pre_login_request, notice: "Authentication successful!"
      else
        redirect_to root_url, notice: "Authentication successful!"
      end
    else
      logger.debug ">>>>>>> user failed login"
      redirect_to '/login'
      flash.alert = "Credentials incorrect."
    end
  end

  def login
  end

  def destroy
    reset_session
    redirect_to root_url
  end

  # GET welcome
  def welcome
  end

  # GET authorized
  def page_requires_login
  end
end
