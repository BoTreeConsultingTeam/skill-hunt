require 'spec_helper'

describe Company do
  let(:company) { Company.new }

  it { should respond_to(:name) }
  
  context "#name" do
    let!(:errors){ company.save; company.errors }
    
    it "can not be blank" do
      expect(errors).to_not be_empty
    end
    
    it "when blank shows user-friendly message" do
      expect(errors[:name]).to include("is required")
    end 
  end

  it "belongs to Country" do
    skip
  end

  it "has list of Skills" do
    skip
  end
end
