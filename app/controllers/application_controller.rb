class ApplicationController < ActionController::Base
  before_filter :biduribulan_config
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "Access denied!"
    redirect_to root_url
  end
  
private

  def biduribulan_config
    Entry.read_entry_type
  end

  def require_role(*roles)
    if current_user
      unless (current_user.role_symbols & roles).length > 0
        store_location
        flash[:notice] = "Harus login"
        redirect_to home_path
        return false
      end
    elsif
      store_location
      flash[:notice] = "Harus login"
      redirect_to home_path
      return false
    end
  end
  
  # Restudent last user location before signing in
  def store_location
    session[:return_to] = request.fullpath
  end
end
