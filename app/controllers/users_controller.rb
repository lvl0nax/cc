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
    @title = "Мой календарь"
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
      @message = 'Parol zmineno'
    else
      @message = 'Error'
    end    
  end
end