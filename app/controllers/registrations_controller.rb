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
    role = params[:user][:role][:name]
    params[:user][:role] = nil
    if role == "employer" or role == "employee"
      temp = User.count
      super

      if temp == 0
        @user.role = Role.new(:name => "admin")
        @user.resume = Resume.new(params[:user][:resume])
      else
        @user.role = Role.new(:name => role)
        @user.resume = Resume.new(params[:user][:resume]) if role == "employee"
        @user.compinfo = Compinfo.new(params[:user][:compinfo]) if role == "employer"
      end

      redirect_to edit_compinfo_path(@user.compinfo) if role == 'employer'
      redirect_to edit_resume_path(@user.resume) if role == 'employee'

      flash[:register] = true

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
    if @user.role?(:admin) #|| @user.role?(:admin))
      #TODO: make redirect to self user profile

      redirect_to root_path 
    end
  end

  

end