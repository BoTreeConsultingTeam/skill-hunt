require 'spec_helper'
require 'shared_examples'

describe Company do
  let(:company) { Company.new }

  it { should respond_to(:company_name) }
  
  context "#company_name" do
    it_should_behave_like "check", [Company.new, :company_name, "is required"]
    
=begin    
    let!(:errors){ company.save; company.errors }
    
    it "can not be blank" do
      expect(errors).to_not be_empty
    end
    
    it "when blank shows user-friendly message" do
      expect(errors[:company_name]).to include("is required")
    end 
=end  
  end

  it "belongs to Country" do
    skip
  end

  it "has list of Skills" do
    skip
  end
end
