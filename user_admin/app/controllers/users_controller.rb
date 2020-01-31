class UsersController < ApplicationController

    include AdminsHelper
    def index
        #@users = User.all
    end

    def new
        @user = User.new
    end

    def create
        #byebug
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
            flash[:error] = "Account Successfully Created"
            redirect_to users_sigin_path
            return
        end
        render 'new'
    end

    def show
        @user = User.find_by(id: session[:user_id])
        if @user == nil
            redirect_to users_sigin_path
        end
    end
    def logout
        session[:authenticate]=false
        flash[:success] = "You have successfully logged out!"
        session[:user_id] = nil
        redirect_to users_sigin_path
    end


    def sigin
        if request.post?
            #byebug
            @user = User.find_by(email: params[:user][:email] )
            if @user == nil
                flash[:error] = "Please Enter correct Details"
                redirect_to users_sigin_path
            else
                if @user.email == params[:user][:email]  and @user.password == params[:user][:password]
                    session[:authenticate] = true
                    session[:expires_at] = Time.current + 10.minutes
                    flash[:success] = "You have Successfully logged in!" 
                    session[:user_id] = @user.id
                    redirect_to users_path
                else
                    session[:errors]='error'
                    flash[:success] = "Either Email or Password is incorrect" 
                    redirect_to users_sigin_path
                end
            end
            
        else
            
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

    private
        def user_params
            #byebug
            params.require(:user).permit(:name, :email, :phone, :password, :parent)
        end
        def signin_params
            #byebug
            params.require(:user).permit(:email, :password)
        end
end