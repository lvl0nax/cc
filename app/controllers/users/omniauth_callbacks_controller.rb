class Users::OmniauthCallbacksController < ApplicationController
  def facebook
  	@user = User.find_for_facebook_oauth(request.env["omniauth.auth"], "employee")
    if @user.persisted?
     
      name = request.env["omniauth.auth"][:info][:first_name]
      l_name = request.env["omniauth.auth"][:info][:last_name]
      description = request.env["omniauth.auth"][:info][:description]

      gender = I18n.t request.env["omniauth.auth"][:extra][:raw_info][:gender]
      count = request.env["omniauth.auth"][:extra][:raw_info][:education].count
      scool_name = request.env["omniauth.auth"][:extra][:raw_info][:education][count-1][:school][:name]
      type_ed = I18n.t request.env["omniauth.auth"][:extra][:raw_info][:education][count-1][:type]
      concentration = request.env["omniauth.auth"][:extra][:raw_info][:education][count-1][:concentration][0][:name]
   
      if @user.resume.nil? 
        @user.resume  = Resume.new(:name=>name,:surname=>l_name,:gender=>gender,:education=>type_ed,
          :university=>scool_name, :faculty=>concentration, :description=>description )
      end
      
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end

  def vkontakte
  	@user = User.find_for_vkontakte_oauth(request.env["omniauth.auth"], "employee")
    if @user.persisted?
      @user.resume = Resume.new()
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Vkontakte"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end

  def failure
    render :text => params.inspect
  end
end
