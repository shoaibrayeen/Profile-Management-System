class ApplicationController < ActionController::Base
	before_action :check_session

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** check session
=end
	def check_session
		if session[:expires_at] == nil
		  session[:expires_at]= Time.now
		end
		if session[:expires_at] < Time.current
		  session[:authenticate]=false
		end
	end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** check authorization for admin
=end
	def authorized
		redirect_to '/admin/' unless logged_in?
	end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** check if admin is logged in
=end
	def logged_in?
		!current_user.nil?
	end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** check if admin exists or not
=end
	def current_user
    	@current_u ||= Admin.find_by(username: session[:username])
	end

	
=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** check authorization for user
=end
    def authorize
    	if logged_in?
    		return
    	else
    		redirect_to '/' unless logged_in2?
    	end
	end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** check if user is logged in
=end

	def logged_in2?
		!current_user2.nil?
	end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** check if user exists or not
=end
	def current_user2
		@admin_current ||= User.find_by(id: session[:user_id])
	end	

end