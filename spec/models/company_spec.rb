require 'spec_helper'

describe Company do
  let(:company) { Company.new }

  it { should respond_to(:company_name) }
  
  context "#company_name" do
    
    let!(:errors){ company.save; company.errors }
    
    it "can not be blank" do
      expect(errors).to_not be_empty
    end
    
    it "when blank shows user-friendly message" do
      expect(errors.messages[:company_name]).to include("is required")
    end   
  end

end
