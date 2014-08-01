require 'spec_helper'

describe Api::V1::CountriesController, type: :controller do
  include_context 'initialized_objects_for_country'

  let!(:current_user) { update_user_authentication(dummy_auth_token, admin_user) }

  before do
    params.merge!(country_attrs)
  end

  def expected_keys_in_json
    %w(id country_name)
  end

  def modify_country_attribute(attribute,value)
    params[:country][attribute] = value
  end

  def get_error(attribute)
    country_json['errors'][attribute]
  end

  def non_exists_country_id
    -1
  end

  context '#create' do 
    def create_country
      post :create, params
    end

    it "successfully creates a country" do
      expect { create_country }.to change(Country,:count).by(1)
    end

    it "returns the response code as 201" do 
      create_country
      expect(response.status).to eq 201
    end

    it "returns the created country's json" do
      create_country
      expect(country_json.keys).to eql(expected_keys_in_json)
    end

    context "displays error" do
      it "when country name is missing" do
        modify_country_attribute(:country_name, '')
        create_country
        expect(get_error('country_name')).to include("is required")
      end

      it "when an end user tries to create country" do        
        set_current_user(end_user)
        expect { create_country }.to change(Country,:count).by(0) 
      end
    end
  end

  context "#update" do 
    let!(:country) { Country.create(country_name: 'Brazil') }

    before do       
        params.merge!(country_attrs)
    end

    def update_country(id)
      params[:id] = id
      put :update, params  
    end

    it "successfully updates the country name" do
      modify_country_attribute(:country_name, 'Canada')
      update_country(country.id)
      expect(country_json['country_name']).to include "Canada"
    end

    it "returns updated country's json" do
      modify_country_attribute(:country_name, 'Canada')
      update_country(country.id)
      expect(country_json.keys).to eql expected_keys_in_json
    end

    it "returns response code as 200" do
      update_country(country.id)
      expect(response.status).to eq 200
    end 

    context "display error" do
      it "when country name is blank" do
        modify_country_attribute(:country_name, '')
        update_country(country.id)
        expect(get_error('country_name')).to include("is required")
      end

      it "when country is not present" do
        update_country(non_exists_country_id)
        expect(response_json['error']).to_not be_empty
      end

      it "when an end user tries to update country" do        
        set_current_user(end_user)
        update_country(country.id)
        expect(response_json["errors"]).to_not be_empty
        expect(country.country_name).to include "Brazil"
      end
    end
  end

  context '#destroy' do
    let!(:country) { Country.create(country_name: 'Brazil') }

    def delete_country(id)
      params[:id] = id
      delete :destroy, params
    end

    it 'shows action not supported error message' do
      delete_country(country.id)
      expect(response.status).to be 501
    end    
  end

   context "#show" do
    let!(:country) { Country.create(country_name: 'Brazil') }

    def show_country(id)
      params[:id] = id
      get :show, params
    end
    
    it 'shows country' do
      show_country(country.id)
      expect(country_json.keys).to eql expected_keys_in_json
    end

    it 'shows error when country does not exist' do
      show_country(non_exists_country_id)
      expect(response_json['error']).to_not be_empty
    end
  end
end