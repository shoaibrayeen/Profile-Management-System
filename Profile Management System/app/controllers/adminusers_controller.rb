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

        flash[:success] = "Account Created and You are logged In"
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
  
=begin
    id_info = User.get_user_info_by_id(params[:id])
    # Case 1 -> When Admin is not changing Parent
    if id_info.parent_id == params[:parent_id]

    # Case 2-> When Parent is Removed
    elsif params[:parent_id] == ""
    
    # Case 3 -> Entered Parent is different  
    elsif id_info.parent_id != params[:parent_id]

    end
    
    child_count = User.get_child_count(params[:parent_id])
    flag = 0
    if child_count == 4
      flash[:error] = "Can't have more than 4 Child"
      flag = 1
    elsif 
      @adminObj = User.update_info(params)
      if @adminObj == nil
        flash[:error] = "Parent Must Exist"
        flag = 1;
      elsif @adminObj == false
        flash[:error] = "Kindly check your details -> Name: Min 3, Email: should be an email, Password: Min 6, Contact: Should be numerical and Len 10"
        flag = 1;
      elsif @adminObj == "404"
        flash[:error] = "Can't have more than 2 level"
        flag = 1;
      else
        flash[:success] = 'Information Updated Successfully!'
        flag = 0
      end
    end
    
    if flag = 0
      redirect_to adminuser_path
    else
      redirect_to edit_adminuser_path
    end
=end
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
  end

  def update_parent
    render plain: params
  end

end
