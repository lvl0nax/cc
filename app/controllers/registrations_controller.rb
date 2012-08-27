class RegistrationsController < Devise::RegistrationsController
  
  # add some code to devise method CREATE
  def create  
    temp = User.count
  	super

  	if temp == 0
      @user.role = Role.new(:name => "admin")
  	else
      @user.role = Role.new(:name => params[:user][:role])
  	end
  end

  def profile
    @user = Page.find(params[:user])

    #checking for admin role.
    # if it's profile of the admin, you will be redirect to root
    #TODO: checking all variants with possibility to see the profile.
    if (@user.role?(:admin) )#|| @user.role?(:admin))
      #TODO: make redirect to self user profile

      redirect_to root_path 
    end
  end

  

end