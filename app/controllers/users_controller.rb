class UsersController < ApplicationController
  before_filter :require_login, :only => :list
  before_filter :require_anon, :only => :login

  # Home page
  def index
    if params[:email]
      @user = User.new :email => params[:email] 
    else
      @user = User.new
    end
    
    respond_to do |format|
      format.html
    end
  end  

  def list
    @users = User.all
    respond_to do |format|
      format.html
    end
  end
 
  def create
    @user = User.new(params[:user])
    
    if @user.save
      Notifier.subscribe(@user).deliver
      @user = User.new
      flash.now[:notice] = "Thanks for signing up!"
    else
      flash.now[:error] = "Hmn, let's try that again."
    end
    
    respond_to do |format|      
      format.html { render :action => 'index' }
    end
    
  end

  def login 
    @login = Login.new
  end

  def trylogin
    if params[:login][:password] == "admin"
      session[:admin] = true
      flash[:notice] = "Thank you. Here is a list of others who have registered."
      redirect_to :action => 'list'
    else
      flash[:error] = "Sorry, that is not the correct password."
      redirect_to :action => 'login'
    end
  end

  def logout
    if logged_in?
      session[:admin] = nil
      flash[:notice] = "You have been logged out."
    end
    
    redirect_to :action => 'index'
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash.now[:notice] = "You have been unsubscribed. Sorry to see you go!"
    else
      flash.now[:error] = "Looks like you've already unsubscribed!"
    end
    
    redirect_to :action => 'index'
  end
  
end
