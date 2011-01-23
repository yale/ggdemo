class User < ActiveRecord::Base
  validates_presence_of :name, :on => :create, :message => "What's your name?"
  validates_presence_of :email, :on => :create, :message => "We'd like to stay in touch; what's your email address?"
  validates_uniqueness_of :email, :on => :create, :message => "Looks like we've already got you on our list. We'll email you soon with updates! Meanwhile, feel free to login using the link below."
  validates :email, :email_pattern => true

end
