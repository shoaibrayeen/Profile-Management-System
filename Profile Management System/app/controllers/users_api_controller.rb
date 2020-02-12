class UsersApiController < ApplicationController
    def get_profile
        user = User.get_user_info_by_id(params[:id])
        if user.nil?
            render json: {
                msg: "User Not Found"
            }, status: 404
            return
        end
        render json: {
            id: user.id,
            name: user.name,
            email: user.email,
            contact: user.contact,
            status: user.status

        }, status: 200
    end

    def signin
        user = User.sign_in_validation(params[:email])
        if !user.first
            render json: {
                msg: "User Not Found"
            }, status: 404
            return
        end
        userInfo = User.get_user_info_by_id("#{user[0][:id]}")
        if userInfo.email != params[:email]
            render json: {
                msg: "User Not Found"
            }, status: 404
            return
        elsif userInfo.password == UsersHelper.hash(params[:password].strip) && userInfo.status == "Active"

            render json: {
                id: userInfo.id,
                msg: "Successfully Signed In"

            }, status: 200
            return

        elsif userInfo.status == "Inactive"
            render json: {
                msg: "User is Deactivated"
            }, status: 401
            return
        else
            render json: {
                msg: "Password is Incorrect"
            }, status: 406
            return
        end
    end

    def signup
        user = User.sign_up(params)
        if user
            render json: {
                msg: "Account Created Successfully"

            }, status: 201
        else
            render json: {
                msg: "Error in User Information"

            }, status: 406
        end
    end
end
