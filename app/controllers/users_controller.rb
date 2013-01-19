# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
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
    @action_events = []
    @userevents.each do |ue|
      @action_events += EventParent.where(:id => ue.event_parent_id, :status => 'ОДОБРЕНО').to_a
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @evnts }
    end
  end

  def admin_page
    authorize! :admin_page, User
    @count = EventParent.any_in(:status => [nil, "УДАЛЕНО", "НОВОЕ"]).count
  end

  def update
    @user = User.find(params[:id])
    puts params

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
    puts "role"
    puts role
    if role == 'employer'
      if not params[:user][:compinfo].nil? and params[:user][:compinfo][:photo] and not cookies[:with_photo]
        puts 'x0'
        user = User.new(params[:user])
        compinfo = Compinfo.new(params[:user][:compinfo])
        user.compinfo = compinfo
        compinfo.save!
        user.save(:validate=>false)
        cookies[:with_photo] = user._id

        return render :json => {:url => compinfo.photo.url}
        #якщо змінив картинку
      elsif params[:user][:compinfo][:photo] and cookies[:with_photo]
        puts 'x1'
        user = User.find(cookies[:with_photo])
        compinfo = Compinfo.new(params[:user][:compinfo])
        user.compinfo = compinfo
        compinfo.save!
        user.save(:validate=>false)
        return render :json => {:url => compinfo.photo.url}
        #поставив картинку і перезагрузив сторінку
      elsif not params[:user][:compinfo][:photo] and cookies[:with_photo] and not params[:user]
        puts 'x2'
        cookies[:delete_user] = cookies[:with_photo]
        cookies.delete :with_photo
      end
    end


    if role == "employer" or role == "employee"
      temp = User.count
         #пошук юзера з картинкою
     if not cookies[:with_photo].nil?
       puts 'x3'
        @user = User.find(cookies[:with_photo]) if role =='employer'
       #загрузив фотку і вирішив створити МС
        if role == 'employee'
          user_delete =  User.find(cookies[:with_photo])
          user_delete.destroy
          cookies.delete :with_photo
        end
        #перезагрузив під-час реєстрації(видалення непотрібного юзера)
     elsif not cookies[:delete_user].nil?
       puts 'x4'
          user_delete =  User.find(cookies[:delete_user])
          user_delete.destroy
          cookies.delete :delete_user
      end
      #user without photo
      if cookies[:delete_user].nil? and cookies[:with_photo].nil?
        puts 'x5'
        puts params[:user]
        @user = User.new(params[:user])
      end
       @user.compinfo(:validate=>false)
      if @user.save
        puts 'x6'
        if temp == 0
          @user.role = Role.new(:name => "admin")
          @user.resume = Resume.new(params[:user][:resume])
        else
          @user.role = Role.new(:name => role)
          @user.resume = Resume.new(params[:user][:resume]) if role == "employee"
          @user.compinfo = Compinfo.new(params[:user][:compinfo]) if role == "employer"
          cookies.delete :with_photo
        end

        flash[:register] = true

        sign_in('user', @user)
        path = edit_compinfo_path(@user.compinfo) if role == "employer"
        path = edit_resume_path(@user.resume) if role == "employee"

        render json:{ success:true, path:path }
      else
        if  @user.errors.count > 0 and not cookies[:with_photo]
          puts 'x7'
          return render json: @user.errors
        elsif not cookies[:with_photo].nil? and @user.errors.count > 0
          puts 'x8'
          if @user.update_attributes(params[:user])
            puts 'x9'
            @user.role = Role.new(:name => role)
            sign_in('user', @user)
            path = edit_compinfo_path(@user.compinfo)
            cookies.delete :with_photo
            puts @user.compinfo.photo.url
            return render :json => { :url => @user.compinfo.photo.url, success:true, path:path }
          else
            puts 'x10'
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
    @items = EventParent.where(:owner => current_user.id)
    @items.each do |item|
      item.visible = true
    end
    @user = current_user
  end
end