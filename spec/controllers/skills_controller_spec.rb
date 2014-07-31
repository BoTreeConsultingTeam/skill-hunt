require 'spec_helper'
require 'shared_context'

describe Api::V1::SkillsController, type: :controller do
  include_context 'initialized_objects_for_skill'

  def dummy_auth_token
    "dummy auth token"
  end

  def update_user_authentication_token(user, auth_token)
    user.update_attribute(:authentication_token, auth_token)
  end

  before do
    params.merge!(skills_attr)
    auth_token = dummy_auth_token
    update_user_authentication_token(admin_user, auth_token)
    params.merge!(authentication_token: auth_token)
  end

  def expected_keys_in_json
    %w(skill_name skill_desc category_id)
  end

  def get_error(attribute)
    skill_json['errors'][attribute]
  end

  def modify_skill_attribute(attribute,value)
    params[:skill][attribute] = value
  end

  def non_exists_skill_id
    -1
  end

  context '#create' do

    def create_skill
      post :create, params
    end

    it 'successfully creates the skill' do
      expect { create_skill }.to change(Skill,:count).by(1)
    end

    it 'returns response code 201' do
      create_skill
      expect(response.status).to be 201
    end

    it 'returns created skill json' do
      create_skill
      expect(skill_json.keys).to eql expected_keys_in_json
    end

    context 'shows error' do

      context 'skill name' do
        it 'is missing' do
          modify_skill_attribute('skill_name','')
          create_skill
          expect(get_error('skill_name')).to include 'is required'
        end

        it 'already exists' do
          skill = Skill.create(skills_attr[:skill])
          modify_skill_attribute('skill_name','Ruby')
          create_skill
          expect(get_error('skill_name')).to include 'has already been taken'
        end
      end

      it 'when skill description is missing' do
        modify_skill_attribute('skill_desc','')
        create_skill
        expect(get_error('skill_desc')).to include 'is required'
      end


      it 'when category is missing' do
        modify_skill_attribute('category_id','')
        create_skill
        expect(get_error('category_id')).to include 'is required'
      end

      it 'if not created by administrator' do 
        auth_token = "end user token"
        update_user_authentication_token(end_user, auth_token)
        params.merge!(authentication_token: auth_token)
        create_skill
        expect(response_json["errors"]).to_not be_empty
        expect(Skill.count).to eq 0  
      end

    end
  end

  context '#update' do

    let!(:skill) { Skill.create(skills_attr[:skill]) }

    def update_skill(id)
      params[:id] = id
      put :update, params  
    end

    it 'successfully updates skill name' do
      modify_skill_attribute('skill_name','Java')
      update_skill(skill.id)
      expect(skill_json['skill_name']).to include 'Java'
    end

    it 'successfully updates skill description' do
      modify_skill_attribute('skill_desc','Pure Object Oriented Language')
      update_skill(skill.id)
      expect(skill_json['skill_desc']).to include 'Pure Object Oriented Language'
    end

    it 'successfully updates category' do
      new_category = Category.create(name: 'Framework')
      modify_skill_attribute('category_id',new_category.id)
      update_skill(skill.id)
      expect(skill_json['category_id']).to eq new_category.id
    end

    context 'show error' do

      context 'skill name' do
        
        it 'is missing' do
          modify_skill_attribute('skill_name','')
          update_skill(skill.id)
          expect(get_error('skill_name')).to include 'is required'
        end

        it 'does not exists' do
          update_skill(-1)
          expect(response_json['error']).to_not be_empty
        end
        
        it 'already exists' do
          new_skill = Skill.create(skill_name: 'Python', 
                                  skill_desc: 'Python Language', 
                                  category_id: category.id)
          
          modify_skill_attribute('skill_name','Python')
          update_skill(skill.id)
          expect(get_error('skill_name')).to include 'has already been taken'
        end

      end

      it 'when skill description is missing' do
        modify_skill_attribute('skill_desc','')
        update_skill(skill.id)
        expect(get_error('skill_desc')).to include 'is required'
      end


      it 'when category is missing' do
        modify_skill_attribute('category_id','')
        update_skill(skill.id)
        expect(get_error('category_id')).to include 'is required'
      end

      it 'if not updated by administrator' do
        modify_skill_attribute(:skill_name, 'C++')
        auth_token = "end user token"
        update_user_authentication_token(end_user, auth_token)
        params.merge!(authentication_token: auth_token)
        update_skill(skill.id)

        expect(response_json["errors"]).to_not be_empty
        expect(category.name).to include 'Database'
      end

    end
  end

  context '#destroy' do
    
    let!(:skill) { Skill.create(skills_attr[:skill]) }

    def delete_skill(id)
      params[:id] = id
      delete :destroy, params
    end

    it 'shows error that action not supported' do
      delete_skill(skill.id)
      expect(response_json['error']).to_not be_empty
    end

  end

  context '#show' do
    let!(:skill) { Skill.create(skills_attr[:skill]) }

    def show_skill(id)
      params[:id] = id
      get :show, params  
    end
    
    it 'returns required skill json' do
      show_skill(skill.id)
      expect(skill_json.keys).to eql expected_keys_in_json
    end

    it 'show error when skill does not exists' do
      show_skill(non_exists_skill_id)
      expect(response_json['error']).to_not be_empty
    end

  end

  context "#like" do

  # let!(:category)  { Category.create(name:"Web Apps") }
                    

  # let!(:user1) { User.create(  first_name:"Ankur1",
  #                             last_name: "Vyas1", 
  #                             gender: "M",
  #                             email: "ankurvy111@gmail.com",
  #                             password: "Ankur12@12",
  #                             blocked: "false",
  #                             country_id: india.id) 
  # }

  #   it "when skill is liked by user", t: true do
  #   skill_one =  Skill.create( skill_name: "Ruby On Rails1",
  #                 skill_desc: "Used to create dynamic websites",
  #                 category_id: category.id ) 
  #     params[:id] = skill_one.id
  #     post :like, params
  #     #puts params
  #     #puts user1.inspect
  #     #puts user1.skills.inspect
  #     expect(user1.skills).to_not be_empty
  #   end

  #   it "display error when skill does not exist" do
  #     params[:id] = -1
  #     post :like, params
  #     expect(response_json["error"]).to_not be_empty
  #   end

  #   it "displays message 'already liked' when skill is already liked by user" do
  #     user1.skills << skill_one
  #     params[:id] = skill_one.id
  #     post :like, params
  #     expect(skill_json["errors"]).to_not be_empty
  #   end
  end
end