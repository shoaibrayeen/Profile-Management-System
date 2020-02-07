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
      if user == "404"
        flash[:error] = 'Either Email or Contact is incorrect!'
        redirect_to users_signin_path
        return
      elsif user == "405"
        flash[:error] = "Account is Deactivated!"
        redirect_to users_signin_path
        return
      elsif user == "406"
        flash[:error] = "Password is incorrect!"
        redirect_to users_signin_path
        return
      else
        session[:user_id] = user
        session[:authenticate] = true
        session[:expires_at] = Time.current + 20.minutes
        flash[:success] = "You have been logged in."
        redirect_to users_path
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
        value = User.find_by( email: params[:email])
=begin
        #byebug
        user = User.sign_in_validation(params[:email].strip)
        for i in 0..(user.length - 1)
          if user[i][:email] == params[:email].strip
            session[:user_id] = user[i][:id]
            break
          end
        end
=end    
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
    @user = User.get_user_info_by_id(session[:user_id])
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Displaying Current User details!    
=end
  def show
    @user = User.get_user_info_by_id(session[:user_id])
  end



  def edit_bio
    @user = User.get_user_info_by_id(session[:user_id])
  end

  def update_bio
    if params[:name] == "" or params[:email] == "" or params[:contact] == ""
      flash[:error] = 'Please Enter All Details'
      redirect_to edit_bio_path
      return
    end

    @user = User.update_user_bio(params)
    if @user == true
      flash[:success] = 'Information Updated Successfully!'
      redirect_to show_path
    else
      flash[:error] = "Kindly Enter Correct Details"
      redirect_to edit_bio_path
    end
  end

  def change_password
  end

  def update_password
    if params[:password] != params[:value] or (params[:password] == "" or params[:value] == "")
      flash[:error] = 'Password Mismatch'
      redirect_to change_password_path
      return
    end
    @user = User.update_user_password(params)
    if @user == true
      flash[:success] = 'Password Changed Successfully!'
      redirect_to show_path
    else
      flash[:error] = 'Error in Password Storing'
      redirect_to change_password_path
    end
  end

end
