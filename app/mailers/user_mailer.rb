

class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def info_email(user)
  	#@user = user #initiate user #user.email,
  	mail(to: "lvl0nax@gmail.com")
  end

  def spamer
  	## TODO: initialize @users variable correctly
  	@users = User.all
  	@users.each { |u| info_email(u) }
  end
end
