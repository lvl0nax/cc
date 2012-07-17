class SessionsController < Devise::SessionsController
  skip_authorize_resource
  skip_authorization_check
end
