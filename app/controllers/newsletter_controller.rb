class NewsletterController < ApplicationController

  # GET /newsletter
  def new
    @user = User.new
    @user.subscribed = true
    
    # On unsuccessful signups, we will push through old parameters to re-populate the form.
    @user.email = params[:email] if params.dig(:email)
  end

  # POST /newsletter
  def create
    if params[:user][:subscribed] == '0'
      flash.alert = "Getting mixed messages. Did you uncheck the subscribe button?"
      redirect_to newsletter_path(email: request.parameters.dig(:user, :email)) and return
    end

    @user = User.create user_params
    if @user.persisted?
      flash.now[:notice] = 'Please check your email for a confirmation link.'
      render :new, status: :ok
    else
      flash.alert = @user.errors.full_messages.to_sentence
      redirect_to newsletter_path(email: request.parameters.dig(:user, :email))
    end
  end

  # GET /newsletter/unsubscribe/quick_unsubscribe_token
  def unsubscribe
    # TODO if @user =, else redirect to subscribe page
    @user = User.find_by(quick_unsubscribe_token: params[:quick_unsubscribe_token])
    if @user.login_allowed?
     @user.subscribed = false
     @user.save!
     redirect_to edit_user_path
    else
      @user.destroy!
      flash.notice = "Unsubscribed and deleted account."
      redirect_to root_path
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :subscribed)
    end

end
