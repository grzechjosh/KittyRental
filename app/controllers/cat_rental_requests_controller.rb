class CatRentalRequestsController < ApplicationController
    def cat_owner
        @validOptions = ["Approved", "Denied", "Pending"]
        @currentCat = Cat.where(id: params[:cat_id]).take!
        @currentRequest = CatRentalRequest.where(id: params[:id]).take!
        @currentStatus = @currentRequest.status.downcase
        if current_user.id == @currentRequest.user_id
            render :edit
        else
            flash[:errors] = "You are not the original requester."
            render :show
        end
    end
    def logged_in
        if current_user.nil?
            flash[:errors] = "You are not logged in."
            redirect_to "/session/new"
        end
    end

    before_action :logged_in, only: [:edit]
    before_action :cat_owner, only: [:edit]
    

    def index
        @currentCat = Cat.where(id: params[:cat_id]).take!
        render :index
    end
    def show
        @validOptions = ["Approved", "Denied", "Pending"]
        @currentCat = Cat.where(id: params[:cat_id]).take!
        @currentRequest = CatRentalRequest.where(id: params[:id]).take!
        @currentStatus = @currentRequest.status.downcase
        render :show
    end
    def edit
        @validOptions = ["Approved", "Denied", "Pending"]
        @currentCat = Cat.where(id: params[:cat_id]).take!
        @currentRequest = CatRentalRequest.where(id: params[:id]).take!
        @currentStatus = @currentRequest.status.downcase
        render :edit
    end
    def update
        currentRequest = CatRentalRequest.where(id: params[:id]).take!
        if !params[cat_cat_rental_request_path]["status"].nil?
            currentRequest.status = params[cat_cat_rental_request_path]["status"]
        end
        if  !params[cat_cat_rental_request_path]["start_date(1i)"].nil?
            currentRequest.start_date = Date.new(params[cat_cat_rental_request_path]["start_date(1i)"].to_i, params[cat_cat_rental_request_path]["start_date(2i)"].to_i, params[cat_cat_rental_request_path]["start_date(3i)"].to_i)
            currentRequest.end_date = Date.new(params[cat_cat_rental_request_path]["end_date(1i)"].to_i, params[cat_cat_rental_request_path]["end_date(2i)"].to_i, params[cat_cat_rental_request_path]["end_date(3i)"].to_i)
        end
        if currentRequest.save
            redirect_to action: "show", id: currentRequest.id
        else
            render json: currentRequest.errors.full_messages
        end
    end
    def new
        @currentCat = Cat.where(id: params[:cat_id]).take!
        @validOptions = [@currentCat.name]
        render :new
    end
    def create
        @currentCat = Cat.where(id: params[:cat_id]).take!
        @thisRequest = CatRentalRequest.new(params.require(:newRequest).permit(:cat_id, :start_date, :end_date))
        @thisRequest.user_id = current_user.id
        if @thisRequest.save
            redirect_to action: "show", id: @thisRequest.id
        else
            render json: @thisRequest.errors.full_messages
        end
    end
end