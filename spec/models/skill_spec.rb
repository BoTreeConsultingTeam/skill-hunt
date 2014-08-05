require 'spec_helper'

describe Skill do
	let (:skill){ Skill.new }
	
	it { should respond_to(:name)}
	it { should respond_to(:desc)}

	context "#name" do 
    let!(:errors) { skill.save; skill.errors }

		it "cannot be blank" do
      expect(errors).to_not be_empty
    end 
    
    it "when blank shows user-friendly message" do
      expect(errors[:name]).to include("is required")
    end
  end

  context "#desc" do 
  	let!(:errors) { skill.save; skill.errors }

  	it "cannot be blank" do
  		expect(errors).to_not be_empty
  	end 

    it "when blank shows user-friendly message" do
      expect(errors[:desc]).to include "is required"
    end
  end

  it "must belong to Category" do
    skip
  end
end
