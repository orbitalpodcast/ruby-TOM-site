class UsersController < ApplicationController
  # When store is implemented, we'll let users edit their profiles. Right now, admins only.
  before_action :authenticate_admin!#,         only: [:index, :show]
  # before_action :authenticate_user_or_admin!, only: [:update, :destroy]
  # before_action :set_user,        only: [:show, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @admins = Admin.all
    @users = User.order :subscribed, :email
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find params[:id]
  end

  # GET /users/new
  # def new
  #   @user = User.new
  #   @user.subscribed = true
    
  #   # On unsuccessful signups, we will push through old parameters to re-populate the form.
  #   @user.email = params[:email] if params.dig(:email)
  # end

  # GET /users/1/edit
  def edit
    @user = User.find params[:id]
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new user_params
    if not @user.subscribed?
      redirect_to new_user_path(email: request.parameters.dig(:user, :email)),
                                errors.add(subscribed: "Wait, you didn't want to sign up?") and return
    end
    if @user.save
      flash.now[:notice] = 'Please check your email for a confirmation link.'
      render :new, status: :ok
      RegistrationMailer.confirmation_instructions(user: @user).deliver_later
    else
      redirect_to new_user_path(email: request.parameters.dig(:user, :email)),
                                errors.add(base: "Something went wrong")
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find params[:id]
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path, notice: 'Preferences successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find params[:id]
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Account deleted.' }
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
      params.require(:user).permit(:email, :subscribed)
    end

end
