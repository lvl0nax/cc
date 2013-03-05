# -*- encoding : utf-8 -*-
class ConnectionsController < ActionController::Base

# after_filter :set_flag_to_nil

  def set_flag_to_nil
     cookies.delete :flag
     cookies.delete :fb_id 
     cookies.delete :vk_id
     cookies.delete :token
   end

  def post_find_location
     location = Geocoder.coordinates(params[:location])
     render :json => (location)
  end
   
   def set_to_nil
    cookies.delete :flag
     cookies.delete :fb_id 
     cookies.delete :vk_id
     cookies.delete :token
     render :json =>""
   end

   def set_user_model_fb_cookies
      cookies.delete :vk_id  if cookies[:vk_id] 
      cookies[:fb_id] = access_token.uid
      cookies[:token] = access_token
      cookies[:flag] = "exists"
   end

 
  def new
    
  end

  def find
    @user = User.where(:email => params[:user_email]).first
    if @user && @user.valid_password?(params[:pass])
  	 
       if cookies[:vk_id]
         @user.connection.update_attribute(:vkontakte_id, cookies[:vk_id])
       elsif cookies[:fb_id]
         @user.connection.update_attribute(:facebook_id, cookies[:fb_id])
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
    @obj = JSON.parse(cookies[:token])
    @user = User.where(:email=>@obj["email"]).to_a
    unless @user.blank?
      render :json => "Пользователь с таким email уже зарегестрирован."
    else

      @username = @obj["name"] if @obj["name"]
      @name = @obj["name"] if @obj["name"]
      @nickname = @obj["username"] if @obj["username"]
      @user = User.create(:provider => @obj["provider"], 
        :url => @obj["urls"] , 
        :username => @username, 
        :name => @name, 
        :nickname => @nickname, 
        :email => @obj["email"], 
        :password => Devise.friendly_token[0,20],
        :role => Role.new(:name => 'employee'))

    
    name = @obj["first_name"]
    l_name = @obj["last_name"]
    description = @obj["description"]
    gender = I18n.t @obj["gender"] if @obj["gender"]
     count = @obj["education"].count unless @obj["education"].blank?
        if not count.nil?
          scool_name = @obj["ed_name"] if count>0
          type_ed = I18n.t @obj["ed_type"] if count>0
          concentration = @obj["ed_concentration"] if @obj["ed_concentration"]
        end

    @user.resume  = Resume.new(:name=>name,:surname=>l_name,:sex=>gender,:education=>type_ed,
            :university=>scool_name, :faculty=>concentration,:description=>description)

    @large_foto = profile_photo_fb("large",@obj["image"],@user.resume)

    # file_foto = File.open(@large, "r")
    # puts file_foto.inspect

    @user.resume.photo = File.open("public#{@large_foto}")
    # @user.resume.photo = File.open('somewhere')
    # @user.resume.photo.save

    @user.resume.save
    @user.connection = Connection.new(:facebook_id =>@obj["uid"])
    set_flag_to_nil
    @path = edit_resume_path(@user.resume) 
    sign_in('user', @user)
    render :json => { :url=> @path, :resume_id =>@user.resume.id }
    # redirect_to path
    end	
  end

  def create_resume_from_social_vk
    @user = User.where(:email=>params[:user_email]).to_a
    unless @user.blank?
      render :json => "Пользователь с таким email уже зарегестрирован."
    else
      @obj = JSON.parse(cookies[:token])
      @user = User.new(
                     :provider => @obj["provider"], 
                     :url => @obj["urls"], 
                     :username => @obj["username"], 
                     # :name => access_token.info.name, 
                     :nickname => @obj["nickname"], #xxx?
                     #:email => request.GET[:email],
                     :email => params[:user_email],
                     :password => Devise.friendly_token[0,20],
                     :role => Role.new(:name => 'employee')
                     )
    @user.email
   unless @user.errors.full_messages.empty?
      render :json => "Email не может быть пустым."
    else
      
      @path = "resumes/"+@user.id.to_s+"/edit"
      render :json => {:status => "true",:url=> @path}
    
      @user.save
          name = @obj["first_name"] if @obj["first_name"]
          l_name = @obj["last_name"] if @obj["last_name"]
          birthday = @obj["bdate"] if @obj["bdate"]
          if birthday
            tmp = birthday.split(".") 
            unless tmp.count < 3
              birthday = tmp.join("-").to_date
            else 
              birthday = nil
            end
          end
          location = @obj[:location]
         
          gender = @obj["gender"]
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
            @large_foto = profile_photo_vk(@obj["photo"],@user.resume)
            @user.resume.photo = File.open("public#{@large_foto}")

            @user.resume.save
          end
      @user.connection = Connection.new(:vkontakte_id =>@obj["uid"])
      set_flag_to_nil()
      sign_in('user', @user)
    end
    end
    end

     def profile_photo_fb(type,obj,resume)
     @first = obj.split("=")[0] << "=#{type}"
     @url = URI.parse(@first)
     @res = Net::HTTP.get_response(@url)
     @url = @res['location']
     @name = @url.split("/")
     @count = @name.count
      Dir.mkdir "public/uploads/resume/photo/#{resume.id}"
      open('public/uploads/resume/photo/'+resume.id.to_s+"/"+@name[@count-1], 'wb') do |file|
      file << open(@url).read
      end
      @path_to_photo = "/uploads/resume/photo/#{resume.id}/#{@name[@count-1]}"
    return @path_to_photo
    
  end
      def profile_photo_vk(obj,resume)
        @url = obj
        @name = @url.split("/")
        @count = @name.count

      Dir.mkdir "public/uploads/resume/photo/#{resume.id}"
      open("public/uploads/resume/photo/#{resume.id}/#{@name[@count-1]}", 'wb') do |file|
      file << open(@url).read
      end
      @path_to_photo = "/uploads/resume/photo/#{resume.id}/#{@name[@count-1]}"
    return @path_to_photo
      end

end
