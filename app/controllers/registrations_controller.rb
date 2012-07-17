class RegistrationsController < Devise::RegistrationsController
 
  skip_authorize_resource
  skip_authorization_check
end