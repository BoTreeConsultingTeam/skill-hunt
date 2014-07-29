require 'spec_helper'


describe Api::V1::UsersController, type: :controller do


  def dummy_auth_token
    "dummy auth token"
  end

  def update_user_authentication_token(user, auth_token)
    user.update_attribute(:authentication_token, auth_token)
  end

  let!(:india) { Country.create(country_name: 'India') }
  let!(:america) { Country.create(country_name: 'America') }
  let(:admin_user_role) { Role.create( role_name:"administrator") }        
  let(:end_user_role)   { Role.create( role_name:"end_user") }
  let(:params) { { format: :json } }
  let(:response_json) { JSON.parse(response.body) }
  let(:user_json) { response_json["user"] }

  let(:user_attrs) {
    {
      user: {
          first_name: "TestFirstName",
          last_name: "TestLastName",
          gender: "M",
          email: "test_email@example.com",
          password: "Test1$aaaaaa",
          country_id: india.id
        }
    }
  }

    let(:user1) { User.create( 
                              first_name: "Raju",
                              last_name: "Bhai",
                              gender: "M",
                              email: "raju@example.com",
                              password: "A1$aaabba",
                              country_id: india.id
                              )
                }
    let(:other_user){
                      User.create(
                        first_name: "Ankur",
                        last_name: "Vyas",
                        gender: "M",
                        email: "ankur@example.com",
                        password: "A1$aaabba",
                        country_id: india.id
                      )
                    }

    let(:admin_user) { user1.role = admin_user_role 
                        user1 } 

    let(:end_user) { other_user.role = end_user_role
                      other_user}

    let(:current_user) { admin_user }

    before do
      params.merge!(user_attrs)

      auth_token = dummy_auth_token
      update_user_authentication_token(admin_user, auth_token)
      params.merge!(authentication_token: auth_token)
    end
  
  context "#create" do

    it "successfully creates a user" do
      expect { post :create, params }.to change(User,:count).by(1)
    end

    it "returns the response code as 201" do
      post :create, params
      expect(response.status).to eq 201
    end

    it "returns the created user's json" do
      post :create, params
      expected_keys_in_json = %w(id first_name last_name gender email blocked)
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
        params[:user][:first_name] = ""
        post :create, params
        expect(user_json['errors']['first_name']).to include "is required"
      end

      it "when last name is missing" do
        params[:user][:last_name] = ""
        post :create, params
        expect(user_json['errors']['last_name']).to include "is required"
      end

      context 'gender' do
      
        it "is missing" do
          params[:user][:gender] = ""
          post :create, params
          expect(user_json['errors']['gender']).to include "must be selected"
        end

        it "is not M or F" do
          params[:user][:gender] = 'A'
          post :create, params
          expect(user_json['errors']['gender']).to include "must be M or F"
        end

      end

      context 'email' do

        it "is missing" do
          params[:user][:email] = ""
          post :create, params
          expect(user_json['errors']['email']).to include "is required"
        end

        it 'not in proper format' do
          params[:user][:email] = "abdf@.com"
          post :create, params
          expect(user_json['errors']['email']).to include 'not valid'
        end

        it "is already taken" do
          user_attrs[:user].delete(:confirm_password)
          user = User.create(user_attrs[:user])
          expect(User.count).to eq 2
   
          params.merge!(user_attrs)         
          post :create, params
          expect(user_json["errors"]["email"]).to include("has already been taken")
        end

      end

      context 'password' do

        it "is missing" do
          params[:user][:password] = ""
          post :create, params
          expect(user_json['errors']['password']).to include "is required"
        end

        it "is less than 8 characters" do
          params[:user][:password] = "a"*6
          post :create,params
          expect(user_json['errors']['password']).to include "should be more than 8 characters"
        end

        it "is more than 20 characters long" do
          params[:user][:password] = "a"*21
          post :create, params
          expect(user_json['errors']['password']).to include "should be less than 20 characters"
        end

        it "does not contain 1 digit, 1 special character or 1 capital letter" do
          params[:user][:password] = "abcdefghij"
          post :create, params
          expect(user_json['errors']['password']).to include "should have atleast 1 capital letter, 1 special symbol and 1 number"
        end
        
      end

      context 'country' do

        it "is missing" do
          params[:user][:country_id] = ""
          post :create, params
          expect(user_json['errors']['country_id']).to include "must be selected"
        end

        it "is not india" do
          country = Country.create(country_name: 'brazil')
          params[:user][:country_id] = country.id
          post :create, params
          expect(user_json['errors']['country_id']).to include "must be india"
        end
      
      end
    end
  end

  context "#update", test: true do

    before do
      params.merge!(user_attrs)  
    end

    let!(:user) { User.create(user_attrs[:user]) } 

    it "successfully updates the first name" do
      params[:user][:first_name] = "Reena"
      params[:id] = user.id               
      put :update, params  
      expect(user_json['first_name']).to include "Reena"
    end
    
    it "successfully updates the last name" do
        params[:user][:last_name] = "Parekh"
        params[:id] = user.id               
        put :update, params  
        expect(user_json['last_name']).to include "Parekh"
    end

    it "returns updated user's json" do
      params[:id] = user.id               
      put :update, params  
    keys = %w(id first_name last_name gender email blocked)
      expect(user_json.keys).to eql keys
    end

    it "returns response code as 200" do
    params[:id] = user.id               
      put :update, params  
      expect(response.status).to eq 200
    end 

    context "shows error" do
      
      it "when first name is missing" do
        params[:user][:first_name] = ""
        params[:id] = user.id               
        put :update, params
        expect(user_json['errors']['first_name']).to include "is required"
      end

      it "when last name is missing" do
        params[:user][:last_name] = ""
        params[:id] = user.id               
        put :update, params
        expect(user_json['errors']['last_name']).to include "is required"
      end

      context 'gender' do

        it "is not selected" do
          params[:user][:gender] = ""
          params[:id] = user.id               
          put :update, params
        expect(user_json['errors']['gender']).to include "must be selected"
        end

        it "is not M or F" do
          params[:user][:gender] = "A"
          params[:id] = user.id               
          put :update, params
      expect(user_json['errors']['gender']).to include "must be M or F"
        end

      end

      it "when country is not india" do
        country = Country.create(country_name: 'brazil')
        params[:user][:country_id] = country.id
        params[:id] = user.id               
        put :update, params
        expect(user_json['errors']['country_id']).to include "must be india"
      end

      it "when user is not present" do
        params[:id] = -1              
        put :update, params
         expect(response_json['error']).to_not be_empty
      end

      it "when email is changed" do
        params[:user][:email] = "rishi.pithadiya@gmail.com"
      params[:id] = user.id               
        put :update, params    
    expect(user_json['errors']['email']).to_not be_empty  
      end

    end
  end

  context "#destroy" do
    
    let!(:user) { User.create(user_attrs[:user]) }

    it "successfully deletes the user"  do
      params[:id] = user.id
      delete :destroy, params
      expect(User.count).to eq 1
    end

    it "shows error when user is not present" do
      params[:id] = -1
      delete :destroy, params
      expect(response_json['error']).to_not be_empty
    end

  end

  context '#show' do

    let!(:user) { User.create(user_attrs[:user]) }
    let!(:end_user1) {  user.role = end_user_role
                        user }

    it "shows details of any user if administrator" do
      params[:id] = other_user.id
      get :show , params
      expected_keys_in_json = %w(id first_name last_name gender email blocked)
      expect(user_json.keys).to eql(expected_keys_in_json)
    end 

    it "display errors when an end user tries to see the details of other user" do        
      auth_token = "End user token "
      update_user_authentication_token(end_user, auth_token)
      params.merge!(authentication_token: auth_token)
    params[:id] = user.id
      get :show , params      
      expect(user_json["errors"]).to_not be_nil
    end
  
    it "display details of current user" do
      auth_token = "End user token "
      update_user_authentication_token(end_user, auth_token)
      params.merge!(authentication_token: auth_token)
      params[:id] = other_user.id
      get :show , params
      expected_keys_in_json = %w(id first_name last_name gender email blocked)
      expect(user_json.keys).to eql(expected_keys_in_json)    
    end
   
    it 'shows error when user does not exists' do
      params[:id] = -1
      get :show, params
      expect(response_json['error']).to_not be_empty      
    end

  end
end