class SessionsController < Devise::SessionsController
  skip_authorize_resource
  skip_authorization_check
  layout false
  respond_to :html, :js

end
