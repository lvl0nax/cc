# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < ApplicationController
  def facebook
  	@user = User.find_for_facebook_oauth(request.env["omniauth.auth"], "employee")
    if @user.persisted?
     
      name = request.env["omniauth.auth"][:info][:first_name]
      l_name = request.env["omniauth.auth"][:info][:last_name]
      description = request.env["omniauth.auth"][:info][:description]

      gender = I18n.t request.env["omniauth.auth"][:extra][:raw_info][:gender]
      count = request.env["omniauth.auth"][:extra][:raw_info][:education].count if request.env["omniauth.auth"][:extra][:raw_info][:education]
      if not count.nil?
      scool_name = request.env["omniauth.auth"][:extra][:raw_info][:education][count-1][:school][:name] if count>0
      type_ed = I18n.t request.env["omniauth.auth"][:extra][:raw_info][:education][count-1][:type] if count>0
      concentration = request.env["omniauth.auth"][:extra][:raw_info][:education][count-1][:concentration][0][:name] if count>0
      end
      # w_count = request.env["omniauth.auth"][:extra][:raw_info][:work].count
      # if w_count>0
        # st_date = request.env["omniauth.auth"][:extra][:raw_info][:work][w_count-1][:start_date]
      # tmp = st_date.split(".")
      # st_date = (tmp.join("-")+"-"+"01").to_date
        # end_date = request.env["omniauth.auth"][:extra][:raw_info][:work][w_count-1][:end_date]
        # tmp = end_date.split(".")
        # end_date = (tmp.join("-")+"-"+"01").to_date
         # elsif w_count=0 
          # end_date = "0"
          # elsif not end_date and w_count>0
        # end_date = Time.now
      # end
      # puts request.env["omniauth.auth"][:extra][:raw_info][:work][w_count-1][:employer][:name]

      # w_name = request.env["omniauth.auth"][:extra][:raw_info][:work][w_count-1][:employer][:name] if w_count>0
      # w_pos = request.env["omniauth.auth"][:extra][:raw_info][:work][w_count-1][:position][:name] if w_count>0
      if @user.resume.nil? 
        @user.resume  = Resume.new(:name=>name,:surname=>l_name,:sex=>gender,:education=>type_ed,
          :university=>scool_name, :faculty=>concentration, :description=>description)
        # @user.resume.save
          # @user.resume.experience_works = ExperienceWork.new(:experience_from=>st_date, :experience_to=>end_date,
          # :experience_company=>w_name, :experience_position=>w_pos)
      # @user.resume.experience_works_attribute = ExperienceWork.new()
        
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
      # @vk = VkontakteApi::Client.new
      uid = request.env["omniauth.auth"][:uid]
      # user_vk = @vk.users.get(uid: uid,fields: [:first_name, :last_name, :education, :university, :online, :counters])
      # education = user_vk
      name = request.env["omniauth.auth"][:extra][:raw_info][:first_name]
      l_name = request.env["omniauth.auth"][:extra][:raw_info][:last_name]
      birthday = request.env["omniauth.auth"][:extra][:raw_info][:bdate]
      tmp = birthday.split(".")
      unless tmp.count < 3
        birthday = tmp.join("-").to_date
      else 
        birthday = nil
      end
      location = request.env["omniauth.auth"][:info][:location]
     
      gender = request.env["omniauth.auth"][:extra][:raw_info][:sex]
      if gender == 1
        gender="женский"
      elsif gender == 2
        gender="мужской"
      else
        gender==" "
      end
    
      if @user.resume.nil?
        @user.resume  = Resume.new(:name=>name,:surname=>l_name,:sex=>gender, :birthday=>birthday, 
          :home=>location) 
      end
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
