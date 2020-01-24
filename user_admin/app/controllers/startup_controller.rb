class StartupController < UsersController
  def signup
    
  end

  def index
    #@user = User.new(signin_params)
    #redirect_to @user
  end

  private
        def signup_params
          params.require(:user).permit(:name, :email, :phone, :password, :parent)
        end

        def signin_params
          params.require(:user).permit(:email, :password)
        end
end
