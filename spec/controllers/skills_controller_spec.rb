require 'spec_helper'

describe Api::V1::SkillsController, type: :controller do
  include_context 'initialize_common_objects'

  let!(:current_user) { update_user_authentication(dummy_auth_token, admin_user) }

  let(:skill_json) { response_json['skill'] }
  let(:category) { FactoryGirl.create(:database_category) } 
  
  let(:skills_attr){
    {
      skill:    
      {
        name: 'OOPS',
        desc: 'Object Oriented Language',
        category_id: category.id
      }
    }
  }

  before do
    params.merge!(skills_attr)
  end

  def expected_keys_in_json
    %w(name desc category_id)
  end

  def get_error(attribute)
    skill_json['errors'][attribute]
  end

  def non_exists_skill_id
    -1
  end

  context '#create' do

    it 'successfully creates the skill' do
      expect { post :create, params }.to change(Skill,:count).by(1)
    end

    it 'returns response code 201' do
      post :create, params

      expect(response.status).to be 201
    end

    it 'returns created skill json' do
      post :create, params

      expect(skill_json.keys).to eql expected_keys_in_json
    end

    context 'shows error' do

      context 'skill name' do

        it 'is missing' do
          params[:skill] = { name: '' }
          
          post :create, params

          expect(get_error('name')).to include 'is required'
        end

        it 'already exists' do
          skill = Skill.create(skills_attr[:skill])
          params[:skill] = { name: 'OOPS' }
          
          post :create, params

          expect(get_error('name')).to include 'has already been taken'
        end
      end

      it 'when skill description is missing' do
        params[:skill] = { desc: '' }
        
        post :create, params
        
        expect(get_error('desc')).to include 'is required'
      end

      it 'when category is missing' do
        params[:skill] = { category_id: '' }
        
        post :create, params

        expect(get_error('category_id')).to include 'is required'
      end

      it 'if an end user tries to create it' do 
        set_current_user(end_user)
        
        post :create, params

        expect(response_json["errors"]).to_not be_empty
        expect(Skill.count).to eq 0  
      end
    end
  end

  context '#update' do

    let!(:skill) { FactoryGirl.create(:java_skill) }

    it 'successfully updates skill name' do
      params[:skill] = { name: 'Java' }

      params[:id] = skill.id
      put :update, params  
      expect(skill_json['name']).to include 'Java'
    end

    it 'successfully updates skill description' do
      params[:skill] = { desc: 'Pure Object Oriented Language' }
      
      params[:id] = skill.id
      put :update, params

      expect(skill_json['desc']).to include 'Pure Object Oriented Language'
    end

    it 'successfully updates category' do
      new_category = FactoryGirl.create(:framework_category)
      params[:skill] = { category_id: new_category.id }

      params[:id] = skill.id
      put :update, params

      expect(skill_json['category_id']).to eq new_category.id
    end

    context 'show error' do

      context 'skill name' do
      
        it 'is missing' do
          params[:skill] = { name: '' }

          params[:id] = skill.id
          put :update, params

          expect(get_error('name')).to include 'is required'
        end

        it 'does not exists' do
          params[:id] = non_exists_skill_id
          put :update, params

          expect(response_json['error']).to_not be_empty
        end
        
        it 'already exists' do
          new_skill = FactoryGirl.create(:python_skill, :category => category)
          params[:skill] = { name: 'Python' }

          params[:id] = skill.id
          put :update, params

          expect(get_error('name')).to include 'has already been taken'
        end
      end

      it 'when skill description is missing' do
        params[:skill] = { desc: '' }

        params[:id] = skill.id
        put :update, params

        expect(get_error('desc')).to include 'is required'
      end

      it 'when category is missing' do
        params[:skill] = { category_id: '' }

        params[:id] = skill.id
        put :update, params

        expect(get_error('category_id')).to include 'is required'
      end

      it 'if not updated by administrator' do
        params[:skill] = { name: 'C++' }
        set_current_user(end_user)

        params[:id] = skill.id
        put :update, params

        expect(response_json["errors"]).to_not be_empty
        expect(category.name).to include 'Database'
      end
    end
  end

  context '#destroy' do

    let!(:skill) { FactoryGirl.create(:java_skill) }

    it 'shows error that action not supported' do
      params[:id] = skill.id
      delete :destroy, params

      expect(response.status).to be 501
    end
  end

  context '#show' do

    let!(:skill) { FactoryGirl.create(:java_skill) }

    it 'returns required skill json' do
      params[:id] = skill.id
      get :show, params  

      expect(skill_json.keys).to eql expected_keys_in_json
    end

    it 'show error when skill does not exists' do
      params[:id] = non_exists_skill_id
      get :show, params  

      expect(response_json['error']).to_not be_empty
    end
  end
  
  context "#like" do

    let!(:category)  { FactoryGirl.create(:framework_category) }

    let!(:skill_1) {  
                      FactoryGirl.create(:dot_net_skill, :category => category) 
                    }

    it 'assigns skill to user, when liked' do
      params.delete(:skill)   

      params[:id] = skill_1.id     
      post :like, params

      expect(admin_user_attrs.skills).to_not be_empty
    end

    it "display error when skill does not exist" do
      params[:id] = non_exists_skill_id
      post :like, params

      expect(response_json["error"]).to_not be_empty
    end

    it "displays message 'already liked' when skill is already liked by user" do
      admin_user_attrs.skills << skill_1

      params[:id] = skill_1.id
      post :like, params

      expect(response_json["error"]).to_not be_empty
    end
  end
end