class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user
  before_action :is_admin_user?, only: [:create, :update, :destroy] 
  before_action :set_user,       only: [:create, :update, :destroy, :show]

  def create
    user = User.new(user_params)
    json = {}
    json = save_user(user)
    render json: json, status: 201
  end

  def update
   json = {}
   unless @user
     render_object_not_found_error_json(:user, params[:id]) and return
   end    

    @user.attributes = user_params 
    json = save_user(@user)
    render json: json, status: 200
  end

  def destroy
    json = {}

    unless @user
      render_object_not_found_error_json(:user, params[:id]) and return
    end   

    @user.destroy      
    render json: json, status: 200
  end

  def show
    json = {}

    unless authorized_user?
      render_forbidden_error_json('Unauthorized action attemped!') and return
    end

    unless @user
      render_object_not_found_error_json(:user, params[:id]) and return
    end
    
    json = model_basic_json(@user)
    render json: json, status: 200
  end	

	private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :gender, :email, :password, :country_id, :authentication_token)
    end

    def authorized_user?
      ( (current_user.id == params[:id].to_i) or is_current_user_administrator? )
    end

    def set_user
      @user = User.find_by_id(params[:id])   
    end
    
    def save_user(user)
        json = {}

        if user.save
          json = model_basic_json(user)
        else
          json = model_errors_json(user)
        end

        json
    end
end