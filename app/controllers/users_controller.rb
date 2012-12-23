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
    @months =  %w[jan feb mar apr may june july aug sept oct nov dec]

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
      @action_events += EventParent.find(ue.event_parent_id).to_a     
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
    if @user.update_attributes(params[:user])
      @message = 'Пароль изменен'
    else
      @message = 'Error'
    end    
  end

  def valid
    role = params[:user][:role][:name]
    params[:user][:role] = nil

    if not params[:user][:compinfo].nil? and params[:user][:compinfo][:photo] and not cookies[:with_photo]
      user = User.new(params[:user])
      compinfo = Compinfo.new(params[:user][:compinfo])

      user.compinfo = compinfo
      compinfo.save!
      user.save(:validate=>false)
      cookies[:with_photo] = user._id
      return render :json => {:url => compinfo.photo.url}
    end

    if role == "employer" or role == "employee"
      temp = User.count

      @user = User.new(params[:user])

      if @user.errors.count > 0 and not cookies[:with_photo]
          return render json: @user.errors

      elsif not cookies[:with_photo].nil? and @user.errors.count > 0
          user = User.find(cookies[:with_photo])
          user.update_attributes(params[:user])
          return render :json => { :url => user.compinfo.photo.url }

      else
        if temp == 0
          @user.role = Role.new(:name => "admin")
          @user.resume = Resume.new(params[:user][:resume])
        else
          @user.role = Role.new(:name => role)
          @user.resume = Resume.new(params[:user][:resume]) if role == "employee"
          @user.compinfo = Compinfo.new(params[:user][:compinfo]) if role == "employer"
          cookies.delete :with_photo if @user.save
        end

        flash[:register] = true
        sign_in('user', @user)
        path = edit_compinfo_path(@user.compinfo) if role == "employer"
        path = edit_resume_path(@user.resume) if role == "employee"

        render json:{ success:true, path:path }
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
  end
end