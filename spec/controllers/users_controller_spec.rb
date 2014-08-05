require 'spec_helper'

describe Api::V1::UsersController, type: :controller do
  include_context 'initialize_common_objects'

  let!(:america_country) { FactoryGirl.create(:america_country) }
  let(:user_json) { response_json['user'] }
  let(:user_attrs) {
    {
      user: 
      {
          first_name: 'TestFirstName',
          last_name: 'TestLastName',
          gender: 'M',
          email: 'test_email@example.com',
          password: 'Test1$aaaaaa',
          country_id: india_country.id
      }
    }
  }

  let!(:current_user) { update_user_authentication(dummy_auth_token, admin_user) }

  def expected_keys_in_json
    %w(id first_name last_name gender email blocked)
  end

  def get_error(attribute)
    user_json['errors'][attribute]
  end

  def non_exists_user_id
    -1
  end

  before do
    params.merge!(user_attrs)
  end
  
  context "#create" do

    it "successfully creates a user" do
      expect { post :create, params }.to change(User,:count).by(1)
    end

    it "returns the response code as 201"  do
      post :create, params
      expect(response.status).to eq 201
    end

    it "returns the created user's json" do
      post :create, params
      expect(user_json.keys).to eql(expected_keys_in_json)
    end

    it "the created user by default should be inactive" do
      post :create, params
      expect(user_json['blocked']).to eq false
    end

    it "send confirmation mail" do
      skip
    end

    it "activates user, when user has been confirmed" do 
      skip
    end

    context "shows an error" do
      it "when first name is missing" do
        params[:user] = { first_name: '' }

        post :create, params

        expect(get_error('first_name')).to include "is required"
      end

      it "when last name is missing" do
        params[:user] = { last_name: '' }

        post :create, params

        expect(get_error('last_name')).to include "is required"
      end

      context 'gender' do

        it "is missing" do
          params[:user] = { gender: '' }

          post :create, params
          
          expect(get_error('gender')).to include "must be selected"
        end

        it "is not M or F" do
          params[:user] = { gender: 'A' }

          post :create, params

          expect(get_error('gender')).to include "must be M or F"
        end
      end

      context 'email' do

        it "is missing" do
          params[:user] = { email: '' }

          post :create, params

          expect(get_error('email')).to include "is required"
        end

        it 'not in proper format' do
          params[:user] = { email: 'abdf@.com' }

          post :create, params

          expect(get_error('email')).to include 'not valid'
        end

        it "is already taken" do
          user = User.create(user_attrs[:user])
          expect(User.count).to eq 2
          params.merge!(user_attrs)         
          
          post :create, params
          
          expect(get_error('email')).to include("has already been taken")
        end
      end

      context 'password' do

        it "is missing" do
          params[:user] = { password: '' }

          post :create, params

          expect(get_error('password')).to include "is required"
        end

        it "is less than 8 characters" do
          params[:user] = { password: 'a'*6 }

          post :create, params

          expect(get_error('password')).to include "should be more than 8 characters"
        end

        it "is more than 20 characters long" do
          params[:user] = { password: 'a'*21 }

          post :create, params

          expect(get_error('password')).to include "should be less than 20 characters"
        end

        it "does not contain 1 digit, 1 special character or 1 capital letter" do
          params[:user] = { password: 'a'*9 }

          post :create, params

          expect(get_error('password')).to include "should have atleast 1 capital letter, 1 special symbol and 1 number"
        end
      end

      context 'country' do

        it "is missing" do
          params[:user] = { country_id: '' }

          post :create, params

          expect(get_error('country_id')).to include "must be selected"
        end

        it "is not india" do
          params[:user] = { country_id: america_country.id }

          post :create, params

          expect(get_error('country_id')).to include "must be india"
        end
      end
    end
  end

  context "#update" do

    let!(:user) { FactoryGirl.create(:user, :country => india_country) } 

    before do
      params.merge!(user_attrs)  
    end

    it "successfully updates the first name" do
      params[:user] = { first_name: 'Reena' }
      
      params[:id] = user.id
      put :update, params  
      
      expect(user_json['first_name']).to include "Reena"
    end
    
    it "successfully updates the last name" do
      params[:user] = { last_name: 'Parekh' }
        
        params[:id] = user.id
        put :update, params  
        
        expect(user_json['last_name']).to include "Parekh"
    end

    it "returns updated user's json" do
      params[:id] = user.id
      put :update, params  
      
      expect(user_json.keys).to eql expected_keys_in_json
    end

    it "returns response code as 200" do
      params[:id] = user.id
      put :update, params

      expect(response.status).to eq 200
    end 

    context "shows error" do
      
      it "when first name is missing" do
        params[:user] = { first_name: '' }
        
        params[:id] = user.id
        put :update, params  
      
        expect(get_error('first_name')).to include "is required"
      end

      it "when last name is missing" do
        params[:user] = { last_name: '' }
        
        params[:id] = user.id
        put :update, params  
        
        expect(get_error('last_name')).to include "is required"
      end

      context 'gender' do

        it "is not selected" do
          params[:user] = { gender: '' }
          
          params[:id] = user.id
          put :update, params  
  	      
          expect(get_error('gender')).to include "must be selected"
        end

        it "is not M or F" do
          params[:user] = { gender: 'A' }
          
          params[:id] = user.id
          put :update, params  
       	  
          expect(get_error('gender')).to include "must be M or F"
        end
      end

      it "when country is not india" do
        params[:user] = { country_id: america_country.id }
        
        params[:id] = user.id
        put :update, params  
        
        expect(get_error('country_id')).to include "must be india"
      end

      it "when user is not present" do
        params[:id] = non_exists_user_id
        put :update, params  
        
        expect(response_json['error']).to_not be_empty
      end

      it "when email is changed" do
        params[:user] = { email: 'rishi.pithadiya@gmail.com' }
    	  
        params[:id] = user.id
        put :update, params  
        
        expect(get_error('email')).to_not be_empty  
      end
    end
  end

  context "#destroy" do

    let!(:user) { FactoryGirl.create(:user, :country => india_country) } 

    it "successfully deletes the user" do
      params[:id] = user.id
      delete :destroy, params 

      expect(User.count).to eq 1
    end

    it "shows error when user is not present" do
      params[:id] = non_exists_user_id
      delete :destroy, params 

      expect(response_json['error']).to_not be_empty
    end
  end

  context '#show' do

    it "shows details of any user if administrator" do
      params[:id] = admin_user.id
      get :show, params

      expect(user_json.keys).to eql(expected_keys_in_json)
    end 

    it "display errors when an end user tries to see the details of other user" do        
      set_current_user(end_user)

      params[:id] = admin_user.id
      get :show, params

      expect(response_json['error']).to_not be_empty
    end
  
    it "display details of current user" do
      set_current_user(end_user)

      params[:id] = end_user.id
      get :show, params

      expect(user_json.keys).to eql(expected_keys_in_json)    
    end
   
    it 'shows error when user does not exists' do
      params[:id] = non_exists_user_id
      get :show, params

      expect(response_json['error']).to_not be_empty      
    end
  end
end