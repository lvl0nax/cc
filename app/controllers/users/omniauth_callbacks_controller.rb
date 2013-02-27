# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < ApplicationController
  def facebook
  	@user = find_for_facebook_oauth(request.env["omniauth.auth"], "employee")
    if @user
      if @user.persisted?
        name = request.env["omniauth.auth"][:info][:first_name]
        l_name = request.env["omniauth.auth"][:info][:last_name]
        description = request.env["omniauth.auth"][:info][:description]

        gender = I18n.t request.env["omniauth.auth"][:extra][:raw_info][:gender]
        count = request.env["omniauth.auth"][:extra][:raw_info][:education].count if request.env["omniauth.auth"][:extra][:raw_info][:education]
        if not count.nil?
          scool_name = request.env["omniauth.auth"][:extra][:raw_info][:education][count-1][:school][:name] if count>0
          type_ed = I18n.t request.env["omniauth.auth"][:extra][:raw_info][:education][count-1][:type] if count>0
          concentration = request.env["omniauth.auth"][:extra][:raw_info][:education][count-1][:concentration][count-1][:name] if concentration
        end
        
        if @user.resume.nil? 
          @user.resume  = Resume.new(:name=>name,:surname=>l_name,:sex=>gender,:education=>type_ed,
            :university=>scool_name, :faculty=>concentration,:description=>description)
        end
        
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        sign_in_and_redirect @user, :event => :authentication
        # sign_in('user', @user) # , :event => :authentication
        # path = edit_compinfo_url(@user.resume)
        # puts 'x'*100
        # puts path
        # asbghjkljkhg
        # redirect_to path
      else
        flash[:notice] = "authentication error"
        redirect_to root_path
      end

    else
      redirect_to root_path
    end
  end

  def vkontakte
  	@user = find_for_vkontakte_oauth(request.env["omniauth.auth"], "employee")
    if @user
      if @user.persisted?
        uid = request.env["omniauth.auth"][:uid]
        name = request.env["omniauth.auth"][:extra][:raw_info][:first_name]
        l_name = request.env["omniauth.auth"][:extra][:raw_info][:last_name]
        birthday = request.env["omniauth.auth"][:extra][:raw_info][:bdate]
        unless birthday.nil?
          tmp = birthday.split(".")
          unless tmp.count < 3
            birthday = tmp.join("-").to_date
          else 
            birthday = nil
          end
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
      else
        redirect_to root_path

    end
  end

  def failure
    render :text => params.inspect
  end

  def self.vk
    User.all.to_a
  end

  def find_for_facebook_oauth(access_token, role)    
    if @user = find_with_facebook(access_token.uid)
    return @user
    else
      @education = ""
      @ed_name = ""
      @ed_concentration = ""  
      
      if access_token.extra.raw_info.education
        @count = access_token.extra.raw_info.education.count 
      
        if @count>0
          @education = access_token.extra.raw_info.education
          @ed_name = access_token.extra.raw_info.education[@count-1][:school][:name]
          @ed_type = access_token[:extra][:raw_info][:education][@count-1][:type]
          @ed_concentration = access_token[:extra][:raw_info][:education][@count-1][:concentration][0][:name] if not access_token[:extra][:raw_info][:education][@count-1][:concentration][0][:name].nil?
        end
      end 
      
      
      @obj = {:uid=>access_token.uid,:email=>access_token.extra.raw_info.email, :urls=>access_token.info.urls.Facebook,
:provider=>access_token.provider,:name=>access_token.extra.raw_info.name, :username=>access_token.extra.raw_info.username,
:first_name=>access_token.info.first_name, :last_name=>access_token.info.last_name, :description=>access_token.info.description,
:gender=>access_token.extra.raw_info.gender, :education=>@education, :ed_name=>@ed_name, :ed_type=>@ed_type, 
:ed_concentration=>@ed_concentration
}
      cookies.delete :vk_id  if cookies[:vk_id] 
      cookies[:fb_id] = access_token.uid
      cookies[:token] = {:value=>@obj.to_json}
      # f = File.new("file2.rb", "w")
      # f.puts(cookies[:token])
      # # f.puts(access_token)
      # f.close
      cookies[:flag] = "exists"       
      return nil
    end
  end

  def find_with_facebook(f_id) 
  @flag = false
  @user_f  
    User.all.to_a.each do |user|
      if user.connection.facebook_id == f_id
        @flag = true
        @user_f = user
        return @user_f
      else
        @flag = false
      end
    end
    if not @flag
      return nil
    end
  end


def find_for_vkontakte_oauth(access_token, role)
    if @user =  find_with_vkontakte(access_token.uid)
     
      return @user
     else
      puts access_token.inspect
      @obj = {:uid=>access_token.uid,:urls=>access_token.info.urls.Vkontakte,
:provider=>access_token.provider, :username=>access_token.info.name,:nickname => access_token.extra.raw_info.domain,
:first_name=>access_token.extra.raw_info.first_name, :last_name=>access_token.extra.raw_info.last_name,
:gender=>access_token.extra.raw_info.sex,:bdate =>access_token.extra.raw_info.bdate, :location=>access_token.info.location
}

       cookies.delete :fb_id  if cookies[:fb_id]
       cookies[:vk_id] = access_token.uid
       cookies[:token] = {:value=>@obj.to_json}
       cookies[:flag] = "exists"
       return nil
    end
  end

  def find_with_vkontakte(v_id)  
   @flag = false
    @user_v      
      User.all.to_a.each do |user|
        if user.connection.vkontakte_id == v_id.to_s
          @flag = true
          @user_v = user
          return @user_v
        else
          @flag = false
        end
      end
      if not @flag
      return nil
      end
  end
end
