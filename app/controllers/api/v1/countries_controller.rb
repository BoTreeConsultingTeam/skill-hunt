class Api::V1::CountriesController < ApplicationController

  before_action :set_country, only: [:create, :update, :destroy, :show]
  before_action :authenticate_user
  before_action :is_admin_user? , only: [:create, :update, :destroy, :show]

  def create
    country = Country.new(country_params)
    json = save_country(country)
    render json: json, status: 201
  end

  def update
    unless @country
      render_object_not_found_error_json(:country, params[:id]) and return
    end

    @country.attributes = country_params
    json = save_country(@country)
    render json: json, status: 200
  end

  def destroy
    render_not_implemented_method_error_json('the functionality is not been supported')
  end

  def show
    unless @country
      render_object_not_found_error_json(:country, params[:id]) and return
    end

    json = model_basic_json(@country)
    render json: json, status: 200
  end

  private

    def save_country(country)
      country.save ? model_basic_json(country) : model_errors_json(country)
    end

    def set_country
      @country = Country.find_by_id(params[:id])
    end

    def country_params
      params.require(:country).permit(:name)
    end
end