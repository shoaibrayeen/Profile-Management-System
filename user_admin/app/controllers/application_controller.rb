class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #before_action :authorized
  helper_method :logged_in?
  helper_method :current_user
  
  
  def current_user   
      User.find_by(id: session[:user_id])
  end

  def logged_in?
      # byebug
      !current_user.nil?  
  end

  helper_method :admin_logged_in?
  helper_method :current_admin
  
  
  def current_admin 
      User.find_by(id: session[:admin_id])
  end

  def admin_logged_in?
      # byebug
      !current_admin.nil?  
  end
  #def authorized
  #  redirect_to '/' unless logged_in?
  #end
end

