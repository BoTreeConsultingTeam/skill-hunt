class Api::V1::CompaniesController < ApplicationController
before_action :set_company, only: [:create, :update, :destroy, :show]
before_action :authenticate_user
before_action :is_admin_user? , only: [:create, :update, :destroy, :show]


  def create
    company = Company.new(company_params)
    json = {}
    json = save_company(company)
    render json: json, status: 201
  end

  def update
    json = {}

    unless @company
      render_object_not_found_error_json(:company, params[:id]) and return
    end

    @company.attributes = company_params
    json = save_company(@company)

    render json: json, status: 200
  end

  def destroy
    render_forbidden_error_json('the functionality is not been supported')
  end

  def show
    json = {}

    unless @company
      render_object_not_found_error_json(:company, params[:id]) and return
    end

    json = model_basic_json(@company)
    render json: json, status: 200
  end

  private

    def save_company(company)
      json = {}

      if company.save
        json = model_basic_json(company)
      else
        json = model_errors_json(company)
      end

      json
    end

    def set_company
      @company = Company.find_by_id(params[:id])
    end

    def company_params
      params.require(:company).permit(:company_name)
    end

end