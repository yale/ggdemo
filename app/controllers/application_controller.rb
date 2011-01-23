class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    @_current_user ||= session[:current_user_id] && User.find(session[:current_user_id])
  end
  
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to :controller => 'users', :action => 'login'
    end
  end
  
  def require_anon
    if logged_in?
      redirect_to :controller => 'users', :action => 'index'
    end
  end

  def logged_in?
    session[:current_user_id] != nil
  end
end
