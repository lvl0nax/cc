class UserMailer2 < ActionMailer::Base
  default from: "spam.ruby29@gmail.com"


  def register(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => user.email,from: "info@centercareer.ru", :subject => "Welcome to My Awesome Site")
  end
  
end
