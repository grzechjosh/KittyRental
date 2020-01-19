class CatsController < ApplicationController

    def index
        render :index
    end
    def show
        @thisCat = Cat.find_by(id: params[:id])
        render :show
    end
    def new
       @valid_colors = ["Black", "White", "Grey", "Orange", "Brown", "Hairless"]
        render :new
    end
    def create
        thisCat = Cat.new(params[:newCat].permit(:name, :sex, :birth_date, :color, :description))
        if thisCat.save
            redirect_to action: "show", id: thisCat.id
        else
            render json: thisCat.errors.full_messages
        end
    end

    def update
        newDate =  Date.new(params[:newCat]["birth_date(1i)"].to_i, params[:newCat]["birth_date(2i)"].to_i, params[:newCat]["birth_date(3i)"].to_i)
        thisCat = Cat.find_by(id: params[:id])
        updateParams = params.require(:newCat).permit(:name, :sex, :birth_date, :color, :description)
        thisCat.name = params[:newCat][:name]
        thisCat.sex = params[:newCat][:sex]
        thisCat.birth_date = newDate
        thisCat.color = params[:newCat][:color]
        thisCat.description = params[:newCat][:description]
        if thisCat.save 
            redirect_to action: "show", id: thisCat.id
        else
            render json: thisCat.errors.full_messages
        end
        
    end

    def edit
        @valid_colors = ["Black", "White", "Grey", "Orange", "Brown", "Hairless"]
        @thisCat = Cat.where(id: params[:id]).take!
        render :update
    end

    
end
