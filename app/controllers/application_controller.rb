# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  #load_and_authorize_resource
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end  

  def admin_only
    return redirect_to root_url if current_user.nil?
    return redirect_to root_url if current_user.role.name != :admin
  end

end
