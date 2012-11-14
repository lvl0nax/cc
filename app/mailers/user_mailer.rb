

class UserMailer < ActionMailer::Base
  default from: "monax.spam@gmail.com"

  def info_email(user)
  	#@user = user #initiate user #user.email,
  	mail(to: "lvl0nax@gmail.com")
  end

  def spamer
  	## TODO: initialize @users variable correctly
  	@users = User.all
  	@users.each { |u| info_email(u) }
  end

  def register(user)
    @user = user
    mail :to => user.email, :from => 'info@centercareer.ru', :subject => 'CareerCenter Registration'
  end


end
