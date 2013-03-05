# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  before_filter :load_resume
  #rescue_from ActionController::RoutingError, :with => :render_404
  #load_and_authorize_resource
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end  

  def admin_only
    redirect_to root_url if current_user.nil?
    redirect_to root_url if current_user.role.name != 'admin'
  end

  def load_resume
    if user_signed_in?
      if current_user.role.name.eql?('employer')
        @compinfo = current_user.compinfo        
      else        
        @resume = current_user.resume        
      end
    end
  end
end
