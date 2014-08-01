require 'spec_helper'

describe Category do
  let(:category) { Category.new }

  it { should respond_to(:name) }

  context "#name" do
    let!(:errors) { category.save; category.errors }

    it "cannot be blank" do         
      expect(errors['name']).to_not be_empty
    end
    
    it "when blank shows user-friendly message" do
      expect(errors[:name]).to include("is required")
    end
  end
  
  it "has list of skills" do
    skip
  end
end