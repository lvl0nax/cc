ActionMailer::Base.default_url_options[:host] = "localhost:3000"
# (Errbit::Application.config.action_mailer.default_url_options ||= {}).tap do |default|
#   default.merge! :host => Errbit::Config.host
# end
# ActionMailer::Base.default_content_type = "text/html"
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :domain          => "gmail.com",
  :address         => 'smtp.gmail.com',
  :port            => 587,
  :authentication  => :plain,
  :user_name       => 'spam.ruby29@gmail.com',
  :password        => 'spam.ruby'
}
