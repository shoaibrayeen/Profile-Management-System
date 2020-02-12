class AdminController < ApplicationController
  before_action :authorized, except: [:signin, :signup]
=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** User can signin and the parameters would be validated!      
=end

  def signin
    if request.get?

    else
      admin = Admin.sign_in(params)
      
      if admin.nil?
        flash[:error] = "Username is Incorrect!"
        redirect_to admin_signin_path

      elsif admin

        session[:username] = params[:username]
        session[:authenticate_admin] = true

        flash[:success] = "You have been logged in."
        redirect_to admin_index_path

      else
        flash[:error] = "Password is Incorrect!"
        redirect_to admin_signin_path
      end

    end
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** New User would be created and Throwing Error if there is any errors     
=end

  def signup
    if request.get?

    else
      admin = Admin.sign_up(params)
      
      if admin
        flash[:success] = "Account Created and Logged In"

        session[:username] = params[:username]
        session[:authenticate_admin] = true

        redirect_to admin_index_path

      else
        flash[:error] = "Error in Details"
        redirect_to admin_signup_path
      end

    end
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Signning Out and Clearing the session      
=end

  def signout
    Rails.cache.write(@current_admin, nil)
    
    session[:username] = nil
    session[:authenticate_admin] = false

    flash[:success] = "You have successfully logged out!"
    redirect_to admin_signin_path
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Elastic Search Result would be printed from here!     
=end
  def search_result
    @adminObj = User.search_record(params)
    if !@adminObj.first
      flash[:Error] = "Either Query is Empty or Record Not Found!"
      redirect_to admin_search_path
    end
  end


=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Showing Admin Information and All the operations, one can perform!    
=end
  def index
    @admin = session[:username]
  end

end
