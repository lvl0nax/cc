class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js
  def new
    @user = User.new
    respond_to do |format|
      format.html { render :layout => false }# new.html.erb
      format.json { render json: @user }
    end
  end

  # add some code to devise method CREATE
  def create  
    role = params[:user][:role]
    
    if ((role == "employer") or (role == "employee"))
      temp = User.count
      flash[:popup] = 'Registration'
    	super

    	if temp == 0
        @user.role = Role.new(:name => "admin")
    	else
        @user.role = Role.new(:name => params[:user][:role])
    	end

    else
      raise "ERROR! incorrect user params!"
    end
  end

  def show
    @user = current_user
    @resume = current_user.resume
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resume }
    end
  end

  def profile
    @user = current_user

    #checking for admin role.
    # if it's profile of the admin, you will be redirect to root
    #TODO: checking all variants with possibility to see the profile.
    if (@user.role?(:admin) )#|| @user.role?(:admin))
      #TODO: make redirect to self user profile

      redirect_to root_path 
    end
  end

  

end