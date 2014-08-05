require 'spec_helper'

describe Api::V1::CompaniesController , :type => :controller do
  include_context 'initialize_common_objects'

  let!(:current_user) { update_user_authentication(dummy_auth_token, admin_user) }
  
  let(:company_json) { response_json["company"] }
  let(:company) { FactoryGirl.build(:beaverlogic_company) }
  let(:company_attrs){
    {
      company: 
      {
        name: 'ThoughtWorks'
      }
    }
  }

  before do
    params.merge!(company_attrs)
  end

  def expected_keys_in_json
    %w(id name)
  end

  def get_error(attribute)
    company_json['errors'][attribute]
  end

  def non_exists_company_id
    -1
  end

  context "#create" do 

    it "successfully creates a company" do 
      expect { post :create, params }.to change(Company,:count).by(1)
    end

    it "returns the response code as 201" do 
      post :create, params

      expect(response.status).to eq 201
    end

    it "returns the created company's json" do
      post :create, params

      expect(company_json.keys).to eql(expected_keys_in_json)
    end

    context "display error" do

      it "when company name is missing" do
        params[:company] = { name: '' }

        post :create, params

        expect(get_error('name')).to include("is required")
      end

      it "when an end user tries to create company" do        
        set_current_user(end_user)

        post :create, params

        expect(response_json["errors"]).to_not be_empty
        expect(Company.count).to eq 0  
      end
    end
  end

  context "#update" do 

    let!(:company) { FactoryGirl.create(:beaverlogic_company) }

    before do       
        params.merge!(company_attrs)
    end

    it "successfully updates the company name" do
      params[:company] = { name: 'BoTree' }
      
      params[:id] = company.id
      put :update, params  

      expect(company_json['name']).to include 'BoTree'
    end

    it "returns updated company's json" do
      params[:company] = { name: 'BoTree' }

      params[:id] = company.id
      put :update, params  

      expect(company_json.keys).to eql expected_keys_in_json
    end

    it "returns response code as 200" do
      params[:id] = company.id
      put :update, params  

      expect(response.status).to eq 200
    end 

    context "shows error" do
      it "if company name is blank" do
        params[:company] = { name: '' }

        params[:id] = company.id
        put :update, params  

        expect(get_error('name')).to include("is required")
      end

      it "if company is not present" do
        params[:id] = non_exists_company_id
        put :update, params  

        expect(response_json['error']).to_not be_empty
      end

      it "if an end user tries to create it" do        
        set_current_user(end_user)

        params[:id] = company.id
        put :update, params  

        expect(response_json["errors"]).to_not be_empty
        expect(company.name).to include 'BeaverLogic'
      end
    end
  end

  context '#destroy' do

    let!(:company) { FactoryGirl.create(:beaverlogic_company) }

    it 'shows error that action not supported' do
      params[:id] = company.id
      delete :destroy, params

      expect(response.status).to be 501
    end
  end

  context "#show" do
    
    let!(:company) { FactoryGirl.create(:beaverlogic_company) }

    it 'shows company' do
      params[:id] = company.id
      get :show, params

      expect(company_json.keys).to eql expected_keys_in_json
    end

    it 'show error when company does not exists' do
      params[:id] = non_exists_company_id
      get :show, params

      expect(response_json['error']).to_not be_empty
    end
  end
end