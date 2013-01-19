class SessionsController < Devise::SessionsController
  skip_authorize_resource
  skip_authorization_check
  layout false
  respond_to :html, :js

  def create
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)

    render :json => true
  end
end
