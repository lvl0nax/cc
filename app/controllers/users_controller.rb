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
    @evnts = @user.created_actions
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @evnts }
    end
  end

  def admin_page
    authorize! :admin_page, User
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
end