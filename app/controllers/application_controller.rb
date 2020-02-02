class ApplicationController < ActionController::Base
  before_action :authorized
  helper_method :current_user
  helper_method :logged_in?

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized
    if ENV['test_skip_authorized'].presence == 'true' and ENV["RAILS_ENV"] == 'test'
      logger.debug ">>>>>>> Skipping authorized!!!"
      return
    end  
    logger.debug ">>>>>>> Authorizing..."
    unless logged_in? and current_user.admin?
      if request.fullpath == '/draft' # Okay I know this seems silly, but at some point, there will be additional pages for admins to access.
        session[:pre_login_request] = request.fullpath
        redirect_to login_url
      else
        not_found # Be sneaky about valid pages that need logins.
      end
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def debug(symb, the_binding=nil)
    var_name = symb.to_s
    if the_binding
      var_value = eval(var_name, the_binding)
      logger.debug ">>>>>>> #{var_name}: #{var_value.inspect}"
    else
      logger.debug ">>>>>>> #{var_name}"
    end
  end

end
