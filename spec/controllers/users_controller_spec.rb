require 'spec_helper'

describe Api::V1::UsersController, type: :controller do
  include_context 'initialized_objects_for_user'

  let!(:current_user) { update_user_authentication(dummy_auth_token, admin_user) }

  def expected_keys_in_json
    %w(id first_name last_name gender email blocked)
  end

  def modify_user_attribute(attribute,value)
    params[:user][attribute] = value
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
    def create_user
      post :create, params
    end

    it "successfully creates a user" do
      expect { create_user }.to change(User,:count).by(1)
    end

    it "returns the response code as 201"  do
      create_user
      expect(response.status).to eq 201
    end

    it "returns the created user's json" do
      create_user
      expect(user_json.keys).to eql(expected_keys_in_json)
    end

    it "the created user by default should be inactive" do
      create_user
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
        modify_user_attribute('first_name','')
        create_user
        expect(get_error('first_name')).to include "is required"
      end

      it "when last name is missing" do
        modify_user_attribute('last_name','')
        create_user
        expect(get_error('last_name')).to include "is required"
      end

      context 'gender' do
        it "is missing" do
          modify_user_attribute('gender','')
          create_user
          expect(get_error('gender')).to include "must be selected"
        end

        it "is not M or F" do
          modify_user_attribute('gender','A')
          create_user
          expect(get_error('gender')).to include "must be M or F"
        end
      end

      context 'email' do
        it "is missing" do
          modify_user_attribute('email','')
          create_user
          expect(get_error('email')).to include "is required"
        end

        it 'not in proper format' do
          modify_user_attribute('email','abdf@.com')
          create_user
          expect(get_error('email')).to include 'not valid'
        end

        it "is already taken" do
          user = User.create(user_attrs[:user])
          expect(User.count).to eq 2
          params.merge!(user_attrs)         
          create_user
          expect(get_error('email')).to include("has already been taken")
        end
      end

      context 'password' do
        it "is missing" do
          modify_user_attribute('password','')
          create_user
          expect(get_error('password')).to include "is required"
        end

        it "is less than 8 characters" do
          modify_user_attribute('password','a'*6)
          create_user
          expect(get_error('password')).to include "should be more than 8 characters"
        end

        it "is more than 20 characters long" do
          modify_user_attribute('password','a'*21)
          create_user
          expect(get_error('password')).to include "should be less than 20 characters"
        end

        it "does not contain 1 digit, 1 special character or 1 capital letter" do
          modify_user_attribute('password','a'*9)
          create_user
          expect(get_error('password')).to include "should have atleast 1 capital letter, 1 special symbol and 1 number"
        end
      end

      context 'country' do
        it "is missing" do
          modify_user_attribute('country_id','')
          create_user
          expect(get_error('country_id')).to include "must be selected"
        end

        it "is not india" do
          modify_user_attribute('country_id',america.id)
          create_user
          expect(get_error('country_id')).to include "must be india"
        end
      end
    end
  end

  context "#update" do
    let!(:user) { User.create(user_attrs[:user]) } 

    before do
      params.merge!(user_attrs)  
    end

    def update_user(id)
      params[:id] = id
      put :update, params  
    end

    it "successfully updates the first name" do
      modify_user_attribute('first_name','Reena')
      update_user(user.id)
      expect(user_json['first_name']).to include "Reena"
    end
    
    it "successfully updates the last name" do
        modify_user_attribute('last_name','Parekh')
        update_user(user.id)
        expect(user_json['last_name']).to include "Parekh"
    end

    it "returns updated user's json" do
      update_user(user.id)
      expect(user_json.keys).to eql expected_keys_in_json
    end

    it "returns response code as 200" do
      update_user(user.id)
      expect(response.status).to eq 200
    end 

    context "shows error" do
      it "when first name is missing" do
        modify_user_attribute('first_name','')
        update_user(user.id)
        expect(get_error('first_name')).to include "is required"
      end

      it "when last name is missing" do
        modify_user_attribute('last_name','')
        update_user(user.id)
        expect(get_error('last_name')).to include "is required"
      end

      context 'gender' do
        it "is not selected" do
          modify_user_attribute('gender','')
          update_user(user.id)
  	      expect(get_error('gender')).to include "must be selected"
        end

        it "is not M or F" do
          modify_user_attribute('gender','A')
          update_user(user.id)
       	  expect(get_error('gender')).to include "must be M or F"
        end
      end

      it "when country is not india" do
        modify_user_attribute('country_id',america.id)
        update_user(user.id)
        expect(get_error('country_id')).to include "must be india"
      end

      it "when user is not present" do
        update_user(non_exists_user_id)
        expect(response_json['error']).to_not be_empty
      end

      it "when email is changed" do
        modify_user_attribute('email','rishi.pithadiya@gmail.com')
    	  update_user(user.id)
        expect(get_error('email')).to_not be_empty  
      end
    end
  end

  context "#destroy" do
    let!(:user) { User.create(user_attrs[:user]) }

    def delete_user(id)
      params[:id] = id
      delete :destroy, params      
    end

    it "successfully deletes the user" do
      delete_user(user.id)
      expect(User.count).to eq 1
    end

    it "shows error when user is not present" do
	    delete_user(non_exists_user_id)
      expect(response_json['error']).to_not be_empty
    end
  end

  context '#show' do
    let!(:user) { User.create(user_attrs[:user]) }

    def show_user(id)
      params[:id] = id
      get :show, params      
    end

    it "shows details of any user if administrator" do
      show_user(other_user_attrs.id)
      expect(user_json.keys).to eql(expected_keys_in_json)
    end 

    it "display errors when an end user tries to see the details of other user" do        
      set_current_user(end_user)
      show_user(user.id)
      expect(response_json['error']).to_not be_empty
    end
  
    it "display details of current user" do
      set_current_user(end_user)
      show_user(other_user_attrs.id)
      expect(user_json.keys).to eql(expected_keys_in_json)    
    end
   
    it 'shows error when user does not exists' do
      show_user(non_exists_user_id)
      expect(response_json['error']).to_not be_empty      
    end
  end
end