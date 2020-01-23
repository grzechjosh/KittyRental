class SessionsController < ApplicationController
    def new
        render :new
    end
    def create
        user = User.find_by(username: login_params[:username])
        if user.nil? 
            flash.now[:errors] = "That username was not found."
            render :new
        else
            if user.is_password?(login_params[:password])
                login!(user)
                redirect_to user_url(user)
            else
                flash.now[:errors] = "That password was incorrect."
                render :new
            end
        end
    end
    def destroy
        logout!
        redirect_to new_session_url
    end
    private
    def login_params
        params.require(:session).permit(:username, :password)
    end
end