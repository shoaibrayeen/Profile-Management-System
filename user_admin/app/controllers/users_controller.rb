class UsersController < ApplicationController
    def index
        @users = User.all
    end
    def new
        @user = User.new
    end


    def create
        @user = User.new(user_params)
        flag = 1
        if @user.parent.empty?
            flag = 0
        else
            data = User.find_by(id: @user.parent)
            if data == nil
                flag = 2
            end
        end

        if @user.save
            redirect_to @user
            return
        end
        render 'new'
    end

    def show
        @user = User.find_by(id: params[:id])
        if @user == nil
            render plain: "Record Not Found"
        end
    end

    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            redirect_to @user
        else
            render 'edit'
        end
    end

    def edit
        show
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
     
        redirect_to users_path
      end

    private
        def user_params
            params.require(:user).permit(:name, :email, :phone, :password, :parent)
        end
end