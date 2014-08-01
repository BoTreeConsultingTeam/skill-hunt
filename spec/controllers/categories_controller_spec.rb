require 'spec_helper'

describe Api::V1::CategoriesController, type: :controller do
  include_context 'initialized_objects_for_category'

  let!(:current_user) { update_user_authentication(dummy_auth_token, admin_user) }

  before do
    params.merge!(categories_attr)
  end

  def expected_keys_in_json
    %w(name)
  end

  def modify_category_attribute(attribute,value)
    params[:category][attribute] = value
  end

  def get_error(attribute)
    category_json['errors'][attribute]
  end

  def non_exists_category_id
    -1
  end

  context "#create" do
    def create_category
      post :create, params
    end

    it "successfully creates the category" do
      create_category
      expect(Category.count).to eq 1
    end

    it 'returns response code 201' do
      create_category
      expect(response.status).to be 201
    end

    it 'returns created category json' do
      create_category
      expect(category_json.keys).to eql expected_keys_in_json
    end

    context "shows error" do
      context 'category name' do
        it "is missing" do
          modify_category_attribute(:name, '')
          create_category
          expect(get_error('name')).to include "is required"
        end
        
        it 'already exists' do
          category = Category.create(categories_attr[:category])
          modify_category_attribute(:name, 'Database')
          create_category
          expect(get_error('name')).to include 'has already been taken'
        end
      end

      it "if an end user tries to create it" do 
        set_current_user(end_user)
        create_category
        expect(response_json["errors"]).to_not be_empty
        expect(Category.count).to eq 0  
      end
    end
  end

  context '#update' do
    let!(:category) { Category.create(categories_attr[:category]) }

    def update_category(id)
      params[:id] = id
      put :update, params  
    end

    it 'successfully updates category name' do
      modify_category_attribute(:name, 'Programming')
      update_category(category.id)
      expect(category_json['name']).to include 'Programming'
    end

    it "returns response code as 200" do
      update_category(category.id)  
      expect(response.status).to eq 200
    end 

    context 'shows error' do
      context 'category name' do
        it 'is missing' do
          modify_category_attribute(:name, '')
          update_category(category.id)
          expect(get_error('name')).to include 'is required'
        end

        it 'does not exists' do
          update_category(non_exists_category_id)
          expect(response_json['error']).to_not be_empty
        end
      
        it 'already exists' do
          new_category = Category.create(name: 'Programming')          
          modify_category_attribute(:name,'Programming')
          update_category(category.id)
          expect(get_error('name')).to include 'has already been taken'
        end
      end

      it 'if not updated by administrator' do
        modify_category_attribute(:name, 'Programming')
        set_current_user(end_user)
        update_category(category.id)

        expect(response_json["errors"]).to_not be_empty
        expect(category.name).to include 'Database'
      end
    end
  end

  context '#destroy' do
    let!(:category) { Category.create(categories_attr[:category]) }

    def delete_category(id)
      params[:id] = id
      delete :destroy, params
    end

    it 'shows error that action not supported' do
      delete_category(category.id)
      expect(response.status).to be 501
    end
  end

  context "#show" do
    let!(:category) { Category.create(categories_attr[:category]) }

    def show_category(id)
      params[:id] = id
      get :show, params
    end
    
    it 'shows category' do
      show_category(category.id)
      expect(category_json.keys).to eql expected_keys_in_json
    end

    it 'show error when category does not exists' do
      show_category(non_exists_category_id)
      expect(response_json['error']).to_not be_empty
    end
  end
end