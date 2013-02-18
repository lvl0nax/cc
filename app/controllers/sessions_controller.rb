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
    $user_id = resource.id
    render :json => true
  end

  def rozsilka_check(old)

    if Time.now.to_i - old > 60  #1209600(2 недели) можно изменить на любое число (сек)
      
      User.first.update_attribute(:timenow,Time.now.to_i)
      id = unisender.getLists()['result'].first['id']
      UserMailer2.spamer(id)      
    end
  end

  def unisender
    @unisender ||= UniSender::Client.new("579fi6mwhe5ea7bj8z8sxt9htq44sygoyburwoto")
  end

  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?
    cookies.delete :flag
     cookies.delete :fb_id
     cookies.delete :vk_id
     cookies.delete :token
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end

end
