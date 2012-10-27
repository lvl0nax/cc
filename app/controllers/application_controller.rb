# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  #load_and_authorize_resource
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

end
