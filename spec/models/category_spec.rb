require 'spec_helper'
require 'shared_examples'

describe Category do
  let(:category) { Category.new }

  it { should respond_to(:name) }

  context "#name" do
    let!(:errors) { category.save; category.errors }

    it "cannot be blank", test: true do         
      expect(errors['name']).to_not be_empty
    end
    
    it "when blank shows user-friendly message" do
      expect(errors[:name]).to include("is required")
    end

    it "contains minimum 8 characters" do
      skip
      category.name = 'abcdef'
      category.save
      expect(errors[:name]).to include "must be more than 8 characters"
    end

    it "contains maximum 30 characters" do
      skip
      category.name = 'a'*31
      category.save
      puts errors[:name]
      expect(errors[:name]).to include "must be less than 30 characters"
    end

  end
  
  it "has list of skills" do
    skip
  end

end