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
      child_count = User.get_child_count(params[:parent_id])
      flag = 0
      if child_count == 4
        flash[:error] = "Can't have more than 4 Child"
        flag = 1
      elsif 
        user = User.sign_up(params)
        if user == nil
          flash[:error] = "Parent Must Exist"
          flag = 1;
        elsif user == false
          flash[:error] = "Kindly check your details -> Name: Min 3, Email: should be an email, Password: Min 6, Contact: Should be numerical and Len 10"
          flag = 1;
        elsif user == "404"
          flash[:error] = "Can't have more than 2 level"
          flag = 1;
        else
          flash[:success] = 'Account Created Successfully!'
          flag = 0
        end
      end
    
      if flag = 0
        redirect_to adminusers_path
      else
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
  end

end
