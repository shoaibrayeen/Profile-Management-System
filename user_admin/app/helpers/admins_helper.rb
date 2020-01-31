module AdminsHelper
    def getData
        User.all
    end
    def newUser
        User.new
    end

    def user_params
        params.permit(:name, :email, :phone, :password, :parent)
    end
end
