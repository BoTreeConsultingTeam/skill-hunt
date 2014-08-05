class Api::V1::SkillsController < ApplicationController

  before_action :set_skill, only: [:create, :update, :destroy, :show, :like]
  before_action :authenticate_user
  before_action :is_admin_user? , only: [:create, :update, :destroy, :show]
  
  def create
    skill = Skill.new(skill_params)
    json = save_skill(skill)
    render json: json, status: 201
  end

  def update
    unless @skill
      render_object_not_found_error_json(:skill, params[:id]) and return
    end    

    @skill.attributes = skill_params
    json = save_skill(@skill)    
    render json: json, status: 200
  end

  def destroy
    render_not_implemented_method_error_json('the functionality is not been supported')
  end

  def show
    unless @skill
      render_object_not_found_error_json(:skill, params[:id]) and return
    end

    json = model_basic_json(@skill)
    render json: json, status: 200
  end

  def like
    unless @skill
      render_object_not_found_error_json(:skill, params[:id]) and return
    end

    if not current_user.skills.exists?(@skill.id)
      current_user.skills << @skill
    else 
      json = error_json("Skill is already liked by user!")  
    end 

    render json: json, status: 200 
  end

  private

    def save_skill(skill)
      skill.save ? model_basic_json(skill) : model_errors_json(skill)
    end

    def set_skill
      @skill = Skill.find_by_id(params[:id])
    end

    def skill_params
      params.require(:skill).permit(:name, :desc, :category_id)
    end
end