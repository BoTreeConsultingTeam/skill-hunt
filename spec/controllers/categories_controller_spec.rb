require 'spec_helper'

describe Api::V1::CategoriesController, type: :controller do
  include_context 'initialize_common_objects'

  let!(:current_user) { update_user_authentication(dummy_auth_token, admin_user) }

  let(:category_json) { response_json['category'] }
  let(:category) { FactoryGirl.build(:database_category) }
  let(:categories_attr){
    {
      category:
      {
        name: 'Language'
      }
    }
  }


  before do
    params.merge!(categories_attr)
  end

  def expected_keys_in_json
    %w(name)
  end

  def get_error(attribute)
    category_json['errors'][attribute]
  end

  def non_exists_category_id
    -1
  end

  context "#create" do
    
    it "successfully creates the category" do
      expect{ post :create, params }.to change(Category,:count).by(1)
    end

    it 'returns response code 201' do
      post :create, params

      expect(response.status).to be 201
    end

    it 'returns created category json' do
      post :create, params
      
      expect(category_json.keys).to eql expected_keys_in_json
    end

    context "shows error" do
    
      context 'category name' do

        it "is missing" do
          params[:category] = { name: '' }
      
          post :create, params
      
          expect(get_error('name')).to include "is required"
        end
        
        it 'already exists' do
          category = Category.create(categories_attr[:category])
          params[:category] = { name: category.name }

          post :create, params
    
          expect(get_error('name')).to include 'has already been taken'
        end
      end

      it "if an end user tries to create it" do 
        set_current_user(end_user)
    
        post :create, params
    
        expect(response_json["errors"]).to_not be_empty
        expect(Category.count).to eq 0  
      end
    end
  end

  context '#update' do

    let!(:category) { FactoryGirl.create(:database_category) }

    it 'successfully updates category name' do
      params[:category] = { name: 'Programming' }

      params[:id] = category.id
      put :update, params  

      expect(category_json['name']).to include 'Programming'
    end

    it "returns response code as 200" do
      params[:id] = category.id
      put :update, params  

      expect(response.status).to eq 200
    end 

    context 'shows error' do

      context 'category name' do

        it 'is missing' do
          params[:category] = { name: '' }

          params[:id] = category.id
          put :update, params  

          expect(get_error('name')).to include 'is required'
        end

        it 'does not exists' do
          params[:id] = non_exists_category_id
          put :update, params  

          expect(response_json['error']).to_not be_empty
        end
      
        it 'already exists' do
          new_category = Category.create(name: 'Programming')    
          params[:category] = { name: 'Programming' }      

          params[:id] = category.id
          put :update, params  

          expect(get_error('name')).to include 'has already been taken'
        end
      end

      it 'if not updated by administrator' do
        params[:category] = { name: 'Programming' }
        set_current_user(end_user)

        params[:id] = category.id
        put :update, params  

        expect(response_json["errors"]).to_not be_empty
        expect(category.name).to include 'Database'
      end
    end
  end

  context '#destroy' do

    let!(:category) { FactoryGirl.create(:database_category) }

    it 'shows error that action not supported' do
      params[:id] = category.id
      delete :destroy, params

      expect(response.status).to be 501
    end
  end

  context "#show" do
    
    let!(:category) { FactoryGirl.create(:database_category) }

    it 'shows category' do
      params[:id] = category.id
      get :show, params

      expect(category_json.keys).to eql expected_keys_in_json
    end

    it 'show error when category does not exists' do
      params[:id] = non_exists_category_id
      get :show, params

      expect(response_json['error']).to_not be_empty
    end
  end
end