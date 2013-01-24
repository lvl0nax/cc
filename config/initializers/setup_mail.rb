ActionMailer::Base.default_url_options[:host] = "localhost:3000"
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :domain          => "gmail.com",
  :address         => 'smtp.gmail.com',
  :port            => 587,
  :authentication  => :plain,
  :user_name       => 'spam.ruby29@gmail.com',
  :password        => 'spam.ruby'
}
