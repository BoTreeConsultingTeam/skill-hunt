require 'spec_helper'

describe Api::V1::CountriesController, type: :controller do
  include_context 'initialize_common_objects'

  let!(:current_user) { update_user_authentication(dummy_auth_token, admin_user) }

  let(:country_json) { response_json["country"] }
  let(:country) { FactoryGirl.build(:brazil_country) }
  let(:country_attrs){
    {
      country: 
      {
        name: 'Australia'
      }
    }
  }

  before do
    params.merge!(country_attrs)
  end

  def expected_keys_in_json
    %w(id name)
  end

  def get_error(attribute)
    country_json['errors'][attribute]
  end

  def non_exists_country_id
    -1
  end

  context '#create' do 

    it "successfully creates a country" do
      expect { post :create, params }.to change(Country,:count).by(1)
    end

    it "returns the response code as 201" do 
      post :create, params

      expect(response.status).to eq 201
    end

    it "returns the created country's json" do
      post :create, params

      expect(country_json.keys).to eql(expected_keys_in_json)
    end

    context "displays error" do
      
      it "when country name is missing" do
        params[:country] = { name: '' }
        
        post :create, params

        expect(get_error('name')).to include("is required")
      end

      it "when an end user tries to create country" do        
        set_current_user(end_user)
        expect { post :create, params }.to change(Country,:count).by(0) 
      end
    end
  end

  context "#update" do 

    let!(:country) { FactoryGirl.create(:brazil_country) }

    before do       
        params.merge!(country_attrs)
    end

    it "successfully updates the country name" do
      params[:country] = { name: 'Canada' }

      params[:id] = country.id
      put :update, params
      
      expect(country_json['name']).to include "Canada"
    end

    it "returns updated country's json" do
      params[:country] = { name: 'Canada' }

      params[:id] = country.id
      put :update, params

      expect(country_json.keys).to eql expected_keys_in_json
    end

    it "returns response code as 200" do
      params[:id] = country.id
      put :update, params

      expect(response.status).to eq 200
    end 

    context "display error" do

      it "when country name is blank" do
        params[:country] = { name: '' }

        params[:id] = country.id
        put :update, params

        expect(get_error('name')).to include("is required")
      end

      it "when country is not present" do
        params[:id] = non_exists_country_id
        put :update, params

        expect(response_json['error']).to_not be_empty
      end

      it "when an end user tries to update country" do        
        set_current_user(end_user)

        params[:id] = country.id
        put :update, params

        expect(response_json["errors"]).to_not be_empty
        expect(country.name).to include 'Brazil'
      end
    end
  end

  context '#destroy' do

    let!(:country) { FactoryGirl.create(:brazil_country) }

    it 'shows action not supported error message' do
      params[:id] = country.id
      delete :destroy, params
    
      expect(response.status).to be 501
    end    
  end

   context "#show" do
    
    let!(:country) { FactoryGirl.create(:brazil_country) }

    it 'shows country' do
      params[:id] = country.id
      get :show, params

      expect(country_json.keys).to eql expected_keys_in_json
    end

    it 'shows error when country does not exist' do
      params[:id] = non_exists_country_id
      get :show, params

      expect(response_json['error']).to_not be_empty
    end
  end
end