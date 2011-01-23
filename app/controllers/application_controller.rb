class ApplicationController < ActionController::Base
  protect_from_forgery
  
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
    session[:admin]
  end
end
