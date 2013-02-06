class NewsletterMailer < ActionMailer::Base
  default from: "from@example.com"

  def weekly(user)
     mail to: user.email, :subject=>"hello!!!!!"
  end
end
