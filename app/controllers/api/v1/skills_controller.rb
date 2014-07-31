class Api::V1::SkillsController < ApplicationController
before_action :set_skill, only: [:create, :update, :destroy, :show, :like]
before_action :authenticate_user
before_action :is_admin_user? , only: [:create, :update, :destroy, :show]
  
  def create
    skill = Skill.new(skill_params)
    json = {}
    json = save_skill(skill)
    render json: json, status: 201
  end

  def update
    json = {} 

    unless @skill
      render_object_not_found_error_json(:skill, params[:id]) and return
    end    

    @skill.attributes = skill_params
    json = save_skill(@skill)    
    render json: json, status: 200
  end

  def destroy
    render_forbidden_error_json('the functionality is not been supported')
  end

  def show
    json = {}

    unless @skill
      render_object_not_found_error_json(:skill, params[:id]) and return
    end

    json = model_basic_json(@skill)
    render json: json, status: 200
  end

  def like
    json = {}

    unless @skill
      render_object_not_found_error_json(:skill, params[:id]) and return
    end
      
    #puts "=================#{current_user.skills.exists?}"
    #puts "=================#{@skill.inspect}"
    #puts "=================#{current_user.inspect}"

    if not current_user.skills.exists?(@skill.id)
      current_user.skills << @skill
      #puts "============user skill = #{current_user.inspect}"
    else 
      json = model_errors_json(current_user) 
    end 

    render json: json, status: 200 
  end

  private

    def save_skill(skill)
      json = {}

      if skill.save
        json = model_basic_json(skill)
      else
        json = model_errors_json(skill)
      end

      json
    end

    def set_skill
      @skill = Skill.find_by_id(params[:id])
    end

    def skill_params
      params.require(:skill).permit(:skill_name, :skill_desc, :category_id)
    end

end