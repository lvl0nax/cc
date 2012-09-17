class UsersController < ApplicationController
	def show
    @user = current_user
    @resume = current_user.resume
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resume }
    end
  end
end