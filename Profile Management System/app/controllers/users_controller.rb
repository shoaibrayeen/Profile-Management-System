=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** User Portal would be accessed!    
=end
class UsersController < ApplicationController
  before_action :authorize, except: [:signin, :signup]
  
=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** User would signin and the parameters would be validated!      
=end
  def signin
    if request.get?
      
    else
      #render plain: params
      user = User.sign_in(params)
      if user.nil?
        flash[:error] = "Either Email or Contact is incorrect!"
        redirect_to users_signin_path

      elsif user
        value = User.get_user_info_by_field(params[:field], params[:value])
        Rails.cache.write(current_user, value)
        
        session[:user_id] = value.id
        session[:authenticate] = true
        session[:expires_at] = Time.current + 20.minutes

        flash[:success] = "You have been logged in."
        redirect_to users_path

      else
        flash[:error] = "Either Account is Deactivated or Password is incorrect!"
        redirect_to users_signin_path
      end

    end
  end


=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** New User can be created!   
=end
  def signup
    if request.get?

    else
      user = User.sign_up(params)
      if user
        value = User.get_user_info_by_field( "email", params[:email])
        Rails.cache.write(current_user, value)

        session[:user_id] = value.id
        session[:authenticate] = true
        session[:expires_at] = Time.current + 20.minutes

        flash[:success] = "Account Created and You are logged In"
        redirect_to users_path
      else
        flash[:error] = "Kindly check your details -> Name: Min 3, Email: should be an email, Password: Min 6, Contact: Should be numerical and Len 10"
        redirect_to users_signup_path
      end
    end
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Signing Out!    
=end
  def signout
    Rails.cache.write(current_user, nil)

    session[:user_id] = nil
    session[:authenticate] = false
    session[:expires_at] = nil

    flash[:success] = "You have successfully logged out!"
    redirect_to users_signin_path
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Displaying Current User details!    
=end
  def index
    @user = Rails.cache.read(current_user)
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Displaying Current User details!    
=end
  def show
    @user = Rails.cache.read(current_user)
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** User can edit the information  
=end
  def edit
    @user = Rails.cache.read(current_user)
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** The modification would be done in the database    
=end
  def update
    @user = User.update_info(params)
    if @user
      flash[:success] = 'Information Updated Successfully!'
      value = User.get_user_info_by_id(params[:id])
      Rails.cache.write(current_user, value)
      redirect_to user_path
    else
      flash[:error] = "Kindly check your details -> Name: Min 3, Email: should be an email, Password: Min 6, Contact: Should be numerical and Len 10"
      redirect_to edit_user_path
    end
  end


end
