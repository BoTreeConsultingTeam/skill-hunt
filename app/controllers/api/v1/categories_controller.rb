class Api::V1::CategoriesController < ApplicationController
  
  before_action :set_category, only: [:create, :update, :destroy, :show]
  before_action :authenticate_user
  before_action :is_admin_user? , only: [:create, :update, :destroy, :show]

  def create
    category = Category.new(category_params)
    json = {}
    json = save_category(category)
    render json: json, status: 201
  end

  def update
    json = {}

    unless @category
      render_object_not_found_error_json(:category, params[:id]) and return
    end

    @category.attributes = category_params
    json = save_category(@category)

    render json: json, status: 200
  end

  def destroy
    render_not_implemented_method_error_json('the functionality is not been supported')
  end

  def show
    json = {}

    unless @category
      render_object_not_found_error_json(:category, params[:id]) and return
    end

    json = model_basic_json(@category)
    render json: json, status: 200
  end

  private

    def save_category(category)
      json = {}

      if category.save
        json = model_basic_json(category)
      else
        json = model_errors_json(category)
      end

      json
    end

    def set_category
      @category = Category.find_by_id(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end

end