class UsersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :update, :edit, :welcome]
  before_action :set_user,        only: [:show, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.subscribed = true
    @user.email = params[:email] if params.dig(:email) # On unsuccessful signups, we will push through old parameters to re-populate the form.
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by access_token: params[:access_token]
  end

  # POST /users
  # POST /users.json
  def create
     @user = User.new( params.require(:user).permit(:email, :subscribed) )
     if not @user.subscribed
      redirect_to new_user_path(email: request.parameters.dig(:user, :email)), notice: "Wait, you didn't want to sign up?" and return
    end
    respond_to do |format|
      if @user.save
        logger.debug ">>>>>>> create successful"
        format.html { redirect_to welcome_path }
        format.json { render :show, status: :ok, location: @user }

        UserMailer.with(user: @user).welcome_email.deliver_later # /rails/mailers/user_mailer/welcome_email
      else
        logger.debug ">>>>>>> create unsuccessful"
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    logger.debug ">>>>>>> users#update invoked" 
    respond_to do |format|
      if @user.update(user_params)
        logger.debug ">>>>>>> update successful"
        format.html { redirect_to edit_user_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        logger.debug ">>>>>>> update unsuccessful"
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by access_token: params[:access_token]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:access_token, :email, :subscribed)
    end

end
