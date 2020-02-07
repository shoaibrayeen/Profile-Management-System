=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** When Admin access user portal, this would be called!     
=end

class AdminusersController < ApplicationController
  before_action :authorized
=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Initially Showing all the results to Admin with Show and Edit Option    
=end

  def index
    @adminObj = User.get_all_user_info
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Calling Show Function of the admin     
=end

  def show
    @adminObj = User.get_user_info_by_id(params[:id])

    if @adminObj.nil?
      flash[:error] = "Record not Found"
      redirect_to adminusers_path
    end

  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Admin would create new User    
=end

  def signup
    if request.get?

    else
      user = User.sign_up(params)
      if user

        flash[:success] = "Account Created!"
        redirect_to adminusers_path
      else
        flash[:error] = "Kindly check your details -> Name: Min 3, Email: should be an email, Password: Min 6, Contact: Should be numerical and Len 10"
        redirect_to adminusers_signup_path
      end

    end
  end


=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** User information would be rendered!  
=end

  def edit

    @adminObj = User.get_user_info_by_id(params[:id])

    if @adminObj.nil?

      flash[:error] = "Record not Found"
      redirect_to adminusers_path

    end

  end


=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Admin can update user's information and can deactivate 
=end
  def update
    if params[:name] == "" or params[:email] == "" or params[:contact] == ""
      flash[:error] = 'Please Enter All Details'
      redirect_to edit_adminuser_path
      return
    end

    @adminObj = User.update_user_bio(params)
    if @adminObj == true
      flash[:success] = 'Information Updated Successfully!'
      redirect_to adminuser_path
    else
      flash[:error] = "Kindly Enter Correct Details"
      redirect_to edit_adminuser_path
    end  

  end

  def change_password
  end

  def update_password
    if params[:password] != params[:value] or (params[:password] == "" or params[:value] == "")
      flash[:error] = 'Kindly Enter Correct Password in Both Field'
      redirect_to admin_change_password_path
      return
    end
    @adminObj = User.update_user_password(params)
    if @adminObj == true
      flash[:success] = 'Password Changed Successfully!'
      redirect_to adminusers_path
    else
      flash[:error] = 'Error in Password Storing'
      redirect_to admin_change_password_path
    end
  end


  def deactivate
    @adminObj = User.user_deactivate(params)
    if @adminObj == "400"
      flash[:error] = 'User Not Found'
    elsif @adminObj == "501"
      flash[:success] = 'User Activated Successfully'
    elsif @adminObj == "502"
      flash[:success] = 'User Deactivated Successfully'
    end  
    redirect_to adminusers_path
  end

  def add_parent
    @adminObj = User.get_user_info_by_id(params[:id])
  end

  def update_parent
    ##byebug
    
    user = User.get_user_info_by_id(params[:id])

    #Case -> Remove Existing Parent
    if params[:parent_id].strip == ""
      user.update_columns(parent_id: params[:parent_id].strip)
      flash[:error] = "Parent Removed Successfully!"
      redirect_to adminusers_path
      return
    end

    #Case -> No Change in Parent
    if user.parent_id == params[:parent_id].strip
      flash[:error] = "No Change in Parent"
      redirect_to adminusers_path
      return
    end
    #Case -> User Enter Same Details
    if params[:id] == params[:parent_id].strip
      flash[:error] = "Can't Enter Parent Id Same As User Id"
      redirect_to adminusers_path
      return
    end
    
    parent_exist  = User.id_validation(params[:parent_id].strip)
                  #User.get_user_info_by_id(params[:parent_id].strip)
    #Case -> Parent Does not Exist
    if !parent_exist.first
      flash[:error] = 'Parent Must Exist'
      redirect_to adminusers_path
      return
    end


    #Counting Number of Child
    child_count = User.get_child_count(params[:parent_id])

    if child_count < 4
      if User.checking_vertical_hierarchy(params[:id], params[:parent_id])
        user.update_columns(parent_id: params[:parent_id].strip)
        flash[:success] = "Parent Updated Successfully"
        redirect_to adminusers_path
        return
      else
        flash[:error] = "Can't have more than 2 Vertical Level"
        redirect_to adminusers_path
        return
      end
      #Check Vertical Level
    else

      #Case 4-> Number of Child is equal to 4
      flash[:error] = "Can't have more than 4 childs"
      redirect_to adminusers_path
      return
    end
  end
end
