class Admin::AuthenticationsController < Admin::BaseController
  load_and_authorize_resource
  
  def index
    @authentications = Authentication.all
  end
end
