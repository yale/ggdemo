class Notifier < ActionMailer::Base
  default :from => "me@yalespector.com"
  
  def subscribe(user)
    @user = user
    
    mail(:to => @user.email, :subject => 'Thank you, ' + @user.name)
  end
end
