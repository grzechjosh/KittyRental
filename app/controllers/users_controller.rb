class UsersController < ApplicationController
    
    def new
        render :new
    end
    def create
        @user =  User.new(user_params)
        if @user.save
           login!(@user)
           redirect_to "/cats"
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end     
    end
    def show
        @showUser = User.find_by(id: params[:id])
        if current_user == nil
            render :alt_show
        else
            if @showUser.id == current_user.id
                render :show
            else
                render :alt_show
            end
        end
    end
    private
    def user_params
        params.require(:newUser).permit(:username, :password)
    end
end
