# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
TestMongoid::Application.initialize!

ActionMailer::Base.default_url_options[:host] = 'localhost:3000'
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "monax.spam@gmail.com",
  :password             => "code4fun",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
