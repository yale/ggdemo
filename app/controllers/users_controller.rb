class UsersController < ApplicationController
  # GET /users
  # GET /users.xml

  # Home page
  def index
    @user ||= User.new
    
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
