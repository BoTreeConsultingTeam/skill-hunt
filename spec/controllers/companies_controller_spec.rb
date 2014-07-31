require 'spec_helper'
require 'shared_context'

describe Api::V1::CompaniesController , :type => :controller do
  include_context 'initialized_objects_for_company'

  def dummy_auth_token
    "dummy auth token"
  end

  def update_user_authentication_token(user, auth_token)
    user.update_attribute(:authentication_token, auth_token)
  end

  before do
    params.merge!(company_attrs)
    auth_token = dummy_auth_token
    update_user_authentication_token(admin_user, auth_token)
    params.merge!(authentication_token: auth_token)
  end

  def expected_keys_in_json
    %w(id company_name)
  end

  def modify_company_attribute(attribute,value)
    params[:company][attribute] = value
  end

  def get_error(attribute)
    company_json['errors'][attribute]
  end

  def non_exists_company_id
    -1
  end

  context "#create" do 

    def create_company
      post :create, params
    end

    it "successfully creates a company" do 
      expect { create_company }.to change(Company,:count).by(1)
    end

    it "returns the response code as 201" do 
      create_company
      expect(response.status).to eq 201
    end

    it "returns the created company's json" do
      create_company
      expect(company_json.keys).to eql(expected_keys_in_json)
    end

    context "display error" do
      it "when company name is missing" do
        modify_company_attribute(:company_name, '')
        create_company
        expect(get_error('company_name')).to include("is required")
      end

      it "display errors when an end user tries to create the company details of other user's company details" do        
        auth_token = "end user token"
        update_user_authentication_token(end_user, auth_token)
        params.merge!(authentication_token: auth_token)
        create_company
        expect(response_json["errors"]).to_not be_empty
        expect(Company.count).to eq 0  
      end
    end
  end

  context "#update" do 
    
    let!(:company) { Company.create(company_attrs[:company]) }

    before do       
        params.merge!(company_attrs)
    end

    def update_company(id)
      params[:id] = id
      put :update, params  
    end

    it "successfully updates the company name" do
      modify_company_attribute(:company_name, 'Wipro')
      update_company(company.id)
      expect(company_json['company_name']).to include "Wipro"
    end

    it "returns updated company's json" do
      modify_company_attribute(:company_name, 'Wipro')
      update_company(company.id)
      expect(company_json.keys).to eql expected_keys_in_json
    end

    it "returns response code as 200" do
      update_company(company.id)
      expect(response.status).to eq 200
    end 

    context "display error" do

      it "when company name is blank" do
        modify_company_attribute(:company_name, '')
        update_company(company.id)
        expect(get_error('company_name')).to include("is required")

      end

      it "when company is not present" do
        update_company(non_exists_company_id)
        expect(response_json['error']).to_not be_empty
      end

      it "display errors when an end user tries to update the company details of other user's company details " do        
        auth_token = "end user token"
        update_user_authentication_token(end_user, auth_token)
        params.merge!(authentication_token: auth_token)
        update_company(company.id)
        expect(response_json["errors"]).to_not be_empty
        expect(company.company_name).to include "TCS"
      end
    end
  end

  context '#destroy' do
    
    let!(:company) { Company.create(company_attrs[:company]) }

    def delete_company(id)
      params[:id] = id
      delete :destroy, params
    end

    it 'shows error that action not supported' do
      delete_company(company.id)
      expect(response_json['error']).to_not be_empty
    end
    
  end

  context "#show" do
 
    let!(:company) { Company.create(company_attrs[:company]) }

    def show_company(id)
      params[:id] = id
      get :show, params
    end
    
    it 'shows company' do
      show_company(company.id)
      expect(company_json.keys).to eql expected_keys_in_json
    end

    it 'show error when company does not exists' do
      show_company(non_exists_company_id)
      expect(response_json['error']).to_not be_empty
    end

  end
end