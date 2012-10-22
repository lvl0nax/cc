class UsersController < ApplicationController
	def show
    @user = current_user
    if (current_user.role.try(:name)=='employee')
    	@resume = current_user.resume
    else
    	@compinfo = current_user.compinfo
    end
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
    #logger.debug "--------------------------------------------"
    @user = User.find(params[:id])
    @actions = @user.actions
    #logger.debug @actions
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @actions }
    end
  end
end