class CatsController < ApplicationController

    def logged_in
        if current_user.nil?
            flash[:errors] = "You are not logged in."
            redirect_to "/session/new"
        end
    end

    def same_user
        @valid_colors = ["Black", "White", "Grey", "Orange", "Brown", "Hairless"]
        @thisCat = Cat.find_by(id: params[:id])
        if current_user.id == @thisCat.user_id
            render :edit
        else
            flash[:errors] = "You are not the owner of this cat."
            render :show
        end
    end
    
    
    before_action :logged_in, only: [:edit]
    before_action :same_user, only: [:edit]

    def index
        render :index
    end
    def show
        @thisCat = Cat.find_by(id: params[:id])
        render :show
    end
    def new
        if current_user.nil?
            redirect_to "/session/new"
        else
       @valid_colors = ["Black", "White", "Grey", "Orange", "Brown", "Hairless"]
        render :new
    end
    def create
        thisCat = Cat.new(params[:newCat].permit(:name, :sex, :birth_date, :color, :description))
        thisCat.user_id = current_user.id
        if thisCat.save
            redirect_to action: "show", id: thisCat.id
        else
            render json: thisCat.errors.full_messages
        end
    end

    def update
        newDate =  Date.new(params[:newCat]["birth_date(1i)"].to_i, params[:newCat]["birth_date(2i)"].to_i, params[:newCat]["birth_date(3i)"].to_i)
        @thisCat = Cat.find_by(id: params[:id])
        updateParams = params.require(:newCat).permit(:name, :sex, :birth_date, :color, :description)
        @thisCat.name = params[:newCat][:name]
        @thisCat.sex = params[:newCat][:sex]
        @thisCat.birth_date = newDate
        @thisCat.color = params[:newCat][:color]
        @thisCat.description = params[:newCat][:description]
        if @thisCat.save 
            flash.now[:messages] = "Your changes were successfully saved."
            render :index
        else
            flash.now[:errors]
            render :edit
        end
    end

 

    def edit  
        @valid_colors = ["Black", "White", "Grey", "Orange", "Brown", "Hairless"]
        @thisCat = Cat.find_by(id: params[:id])
        render :edit
    end 
end
end
