class RolesController < ApplicationController
	def create
		@user = User.find(params[:user_id])
		@role = @user.role.create!(params[:role])
		redirect_to @user
	end	
end
