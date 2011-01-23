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
    @users = User.all(:order => 'name')
    respond_to do |format|
      format.html
    end
  end
  
  def logout
    session[:current_user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to :action => :index
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
    @user = User.new
    
    respond_to do |format|
      format.html
    end
  end

  def trylogin
    if @user = User.find_by_email(params[:user][:email])
      session[:current_user_id] = @user.id
      flash[:notice] = "Thank you. Here is a list of others who have registered."
      redirect_to :action => 'list'
    else
      @user = User.new(params[:user])
      flash.now[:error] = "Looks like you haven't registered quite yet. What's your name?"
      render :action => 'index'
    end
  end

  def logout
    if logged_in?
      session[:current_user_id] = nil
      flash.now[:notice] = "You have been logged out."
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

    respond_to do |format|
      format.html { redirect_to(:action => 'index') }
    end
  end
  
end
