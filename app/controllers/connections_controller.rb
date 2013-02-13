# -*- encoding : utf-8 -*-
class ConnectionsController < ActionController::Base

# after_filter :set_flag_to_nil

  def set_flag_to_nil
     $flag = nil
     $facebook_id = nil
     $vkontakte_id = nil
     $token = nil
   end

  def post_find_location
     location = Geocoder.coordinates(params[:location])
     render :json => (location)
  end
   
def set_to_nil
     $flag = nil
     $facebook_id = nil
     $vkontakte_id = nil
     $token = nil
     render :json =>""
   end

 
  def new
    
  end

  def find
    @user = User.where(:email => params[:user_email]).first
    if @user && @user.valid_password?(params[:pass])
  	 
       if $vk_id
         @user.connection.update_attribute(:vkontakte_id, $vk_id)
       elsif $facebook_id
         @user.connection.update_attribute(:facebook_id, $facebook_id)
       end
     render :json => ( @user && @user.valid_password?(params[:pass]) )
     set_flag_to_nil
     sign_in('user', @user)
    else
      render :json => { :errors => "Неверный пароль или логин" }
    end
  
  	# end
  end

  def create_resume_from_social_facebook
    @user = User.where(:email=>$token.extra.raw_info.email).to_a
    unless @user.blank?
      render :json => "Пользователь с таким email уже зарегестрирован."
    else
      @username = $token.extra.raw_info.name if $token.extra.raw_info.name
      @name = $token.extra.raw_info.name if $token.extra.raw_info.name
      @nickname = $token.extra.raw_info.username if $token.extra.raw_info.username
      
      @user = User.create(:provider => $token.provider, 
        :url => $token.info.urls.Facebook, 
        :username => @username, 
        :name => @name, 
        :nickname => @nickname, 
        :email => $token.extra.raw_info.email, 
        :password => Devise.friendly_token[0,20],
        :role => Role.new(:name => 'employee'))

    name = $token.info.first_name
    l_name = $token.info.last_name
    description = $token.info.description
    gender = I18n.t $token[:extra][:raw_info][:gender] if $token[:extra][:raw_info][:gender]
     count = $token[:extra][:raw_info][:education].count if $token[:extra][:raw_info][:education]
        if not count.nil?
          scool_name = $token[:extra][:raw_info][:education][count-1][:school][:name] if count>0
          type_ed = I18n.t $token[:extra][:raw_info][:education][count-1][:type] if count>0
          concentration = $token[:extra][:raw_info][:education][count-1][:concentration][count-1][:name] if concentration
        end
    @user.resume  = Resume.new(:name=>name,:surname=>l_name,:sex=>gender,:education=>type_ed,
            :university=>scool_name, :faculty=>concentration,:description=>description)
    @user.resume.save
    @user.connection = Connection.new(:facebook_id =>$token.uid)
    set_flag_to_nil
    sign_in_and_redirect('user', @user)
    end	
  end

  def create_resume_from_social_vk
    @user = User.where(:email=>params[:user_email]).to_a
    unless @user.blank?
      render :json => "Пользователь с таким email уже зарегестрирован."
    else
      @user = User.new(
                     :provider => $token.provider, 
                     :url => $token.info.urls.Vkontakte, 
                     :username => $token.info.name, 
                     # :name => access_token.info.name, 
                     :nickname => $token.extra.raw_info.domain, 
                     #:email => request.GET[:email],
                     :email => params[:user_email],
                     :password => Devise.friendly_token[0,20],
                     :role => Role.new(:name => 'employee')
                     )
    @user.email
   unless @user.errors.full_messages.empty?
      render :json => "Email не может быть пустым."
    else
      render :json => "true"
      @user.save
          name = $token[:extra][:raw_info][:first_name] if $token[:extra][:raw_info][:first_name]
          l_name = $token[:extra][:raw_info][:last_name] if $token[:extra][:raw_info][:last_name]
          birthday = $token[:extra][:raw_info][:bdate] if $token[:extra][:raw_info][:bdate]
          if birthday
            tmp = birthday.split(".") 
            unless tmp.count < 3
              birthday = tmp.join("-").to_date
            else 
              birthday = nil
            end
          end
          location = $token[:info][:location]
         
          gender = $token[:extra][:raw_info][:sex]
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
            @user.resume.save
          end
      @user.connection = Connection.new(:vkontakte_id =>$token.uid)
      set_flag_to_nil
      sign_in('user', @user)
    end
    end
    end
    

end
