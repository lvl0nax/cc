class SessionsController < Devise::SessionsController
  skip_authorize_resource
  skip_authorization_check
  layout false
  respond_to :html, :js

  def create
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    rozsilka_check(User.first.timenow)
    sign_in(resource_name, resource)
    render :json => true
  end

  def rozsilka_check(old)
    if Time.now.to_i - old > 10
      User.first.update_attribute(:timenow,Time.now.to_i)
      id = unisender.getLists()['result'].first['id']
      UserMailer2.spamer(id)
    end
    
  end

  def unisender
    @unisender ||= UniSender::Client.new("579fi6mwhe5ea7bj8z8sxt9htq44sygoyburwoto")
  end

end
